//
//  PicCardRecordViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation
import Moya
import MapKit

/// 가게 위치 값 오브젝트
struct PicCardStoreLocation: Equatable, Sendable {
    var name: String
    var latitude: Double?
    var longitude: Double?
    var hasCoordinate: Bool {
        latitude != nil && longitude != nil
    }
}

/// PicCard 업로드 액션을 트리거하고 결과를 UI에 전달하는 뷰모델입니다.
/// - Note: 사이클로매틱 복잡도를 낮추기 위해 에러 메시지 매핑을 전용 헬퍼로 분리했습니다.
@MainActor
@Observable
final class PicCardRecordViewModel {
    private let createCardUseCase: CreateCardUseCase
    private let recordFlowVM: RecordFlowViewModel

    private(set) var isUploading = false
    private(set) var lastCreatedCardId: Int?
    private(set) var errorMessage: String?
    private(set) var isDuplicateMealConflict: Bool = false
    
    var searchResults: [Place] = []

    init(
        container: DIContainer,
        recordFlowVM: RecordFlowViewModel
    ) {
        let provider = container.apiProviderStore.card()
        let repository = CardRepositoryImpl(provider: provider)
        self.createCardUseCase = CreateCardUseCaseImpl(repository: repository)
        self.recordFlowVM = recordFlowVM
    }
    
    var recordFlowState: RecordFlowState {
        recordFlowVM.state
    }
    
    func search(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let self, let mapItems = response?.mapItems else { return }
            
            DispatchQueue.main.async {
                self.searchResults = mapItems.map { Place(mapItem: $0) }
            }
        }
    }
    
    // MARK: - API 호출 및 업로드
    
    /// PicCard 생성을 실행합니다. 중복 업로드를 방지하고, 완료 후 상태를 갱신합니다.
    /// - Important: `RecordFlowViewModel.state`를 스냅샷으로 읽어 사용합니다.
    func createPicCard() async {
        guard !isUploading else { return }
        isUploading = true
        defer { isUploading = false }
        
        errorMessage = nil
        lastCreatedCardId = nil
        
        do {
            let createCardRequestDTO = try CreateCardMapper.makeRequest(from: recordFlowState)
            let cardId = try await createCardUseCase.execute(
                state: recordFlowState,
                request: createCardRequestDTO
            )
            self.lastCreatedCardId = cardId
        } catch {
            self.handle(error)
        }
    }
    
    /// 에러를 사용자 친화적인 메시지로 변환합니다.
    /// - Parameter error: 발생한 에러
    /// - Returns: UI 표시에 적합한 한국어 메시지
    private func userErrMessage(for error: Error) -> String {
        if let err = error as? UploadError {
            return err.errorDescription ?? "업로드 오류가 발생했습니다."
        }
        if let err = error as? APIError {
            switch err {
            case .serverErrorString(let code, let message):
                if code == "CARD_002" {
                    return "이미 같은 날짜와 같은 식사 유형의 카드가 존재합니다."
                }
                return message.isEmpty ? "서버 오류가 발생했습니다." : message
            default:
                return err.errorDescription ?? "요청 처리 중 오류가 발생했습니다."
            }
        }
        
        if let err = error as? MoyaError {
            switch err {
            case .statusCode(let response):
                return handleResponse(response)
            case .underlying(_, let response?):
                return handleResponse(response)
            default:
                return "요청 처리 중 오류가 발생했습니다."
            }
        }
        return "알 수 없는 오류가 발생했습니다."
    }
    
    private func handleResponse(_ response: Response) -> String {
        let parsed = parseServerErrorPayload(from: response.data)
        if parsed.code == "CARD_002" {
            return "이미 같은 날짜와 같은 식사 유형의 카드가 존재합니다."
        }
        return "요청이 실패했습니다(\(response.statusCode))."
    }
    
    /// 에러를 해석하여 UI 바인딩 상태를 갱신합니다.
    private func handle(_ error: Error) {
        // 서버 중복 업로드 충돌 여부 판단
        self.isDuplicateMealConflict = isCard002(error)
        self.errorMessage = userErrMessage(for: error)
    }

    /// 서버에서 내려오는 에러 페이로드를 파싱하여 (code, message)를 추출합니다.
    private func parseServerErrorPayload(from data: Data) -> (code: String?, message: String?) {
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        else { return (nil, nil) }
        let code = json["code"] as? String
        let message = json["message"] as? String
        return (code, message)
    }

    /// CARD_002 (같은 날짜+식사 유형 카드 중복) 여부를 판별합니다.
    private func isCard002(_ error: Error) -> Bool {
        if case let APIError.serverErrorString(code, _) = error {
            return code == "CARD_002"
        }
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response), .underlying(_, let response?):
                let parsed = parseServerErrorPayload(from: response.data)
                return parsed.code == "CARD_002"
            default:
                return false
            }
        }
        return false
    }
}
