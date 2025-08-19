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
            self.errorMessage = userErrMessage(for: error)
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
            return err.errorDescription ?? "요청 처리 중 오류가 발생했습니다."
        }
        if let err = error as? MoyaError {
            switch err {
            case .underlying(let nsError, _):
                return "네트워크 오류: \(nsError.localizedDescription)"
            case .statusCode(let response):
                return "요청이 실패했습니다(\(response.statusCode))."
            default:
                return "요청 처리 중 오류가 발생했습니다."
            }
        }
        return "알 수 없는 오류가 발생했습니다."
    }
}

