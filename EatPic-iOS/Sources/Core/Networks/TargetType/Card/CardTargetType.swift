//
//  CardTargetType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/13/25.
//

import Foundation
import Moya

/// PicCard 생성 요청 본문입니다.
/// - Important: 서버 스키마와 일치해야 하며, 멀티파트의 `request.json` 파트로 전송됩니다.
struct CreateCardRequest: Codable {
    let latitude: Double
    let longitude: Double
    let recipe: String
    let recipeUrl: String
    let memo: String
    let isShared: Bool
    let locationText: String
    let meal: MealSlot
    let hashtags: [String]
}

/// PicCard 생성 결과의 핵심 데이터입니다. 현재는 `newcardId`만 사용합니다.
struct CreateCardResult: Codable {
    let newCardId: Int
    private enum CodingKeys: String, CodingKey {
        case newCardId = "newcardId"
    }
}

enum CardTargetType {
    case fetchFeeds(userId: Int, cursor: Int?, size: Int)
    case createFeed(
        request: CreateCardRequest, image: Data, fileName: String, mimeType: String)
}

extension CardTargetType: APITargetType {
    var path: String {
        switch self {
        case .fetchFeeds:
            return "/api/cards/feeds"
        case .createFeed:
            return "/api/cards"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFeeds:
            return .get
        case .createFeed:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchFeeds(userId, cursor, size):
            var params: [String: Any] = [
                "userId": userId,
                "size": size
            ]
            
            // nil이 아닐 때만 추가
            if let cursor = cursor {
                params["cursor"] = cursor
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case let .createFeed(request, image, fileName, mimeType):
            // 멀티파트 파트 구성:
            // 1) name=`request` (application/json) — CreateCardRequest 직렬화
            // 2) name=`cardImageFile` (image/*) — 인코딩된 이미지 파일
            guard let json = try? JSONEncoder().encode(request) else {
                // 에러 처리를 올려보내거나 최소한 로그
                return .requestPlain
            }
            var parts: [MultipartFormData] = [
                .init(provider: .data(json),
                      name: MultipartField.request,
                      fileName: "request.json",
                      mimeType: "application/json")
            ]
            parts.append(
                .init(provider: .data(image),
                      name: MultipartField.cardImage,
                      fileName: fileName,     // 예: image.heic / image.jpg / image.png
                      mimeType: mimeType)     // 예: image/heic / image/jpeg / image/png
            )
            return .uploadMultipart(parts)
        }
    }
    
    var sampleData: Data {
        return Data("""
         {
           "latitude": 37.5665,
           "longitude": 126.978,
           "recipe": "야채, 아보카도, 소스 조합으로 구성된 샐러드입니다.",
           "recipeUrl": "https://example.com/recipe/123",
           "memo": "오늘은 샐러드를 먹었습니다~ 아보카도를 많이 넣었어요",
           "isShared": true,
           "locationText": "서울특별시 성북구 정릉동",
           "meal": "LUNCH",
           "hashtags": [
             "샐러드",
             "건강식"
           ]
         }
        """.utf8)
    }
}

/// 서버가 기대하는 멀티파트 파트 이름 상수입니다.
/// - Note: Postman 테스트 기준 `cardImageFile`이어야 `cardImageUrl`이 생성됩니다.
enum MultipartField {
    static let cardImage = "cardImageFile"
    static let request = "request"
}

/// PicCard 업로드 액션을 트리거하고 결과를 UI에 전달하는 뷰모델입니다.
/// - Note: 사이클로매틱 복잡도를 낮추기 위해 에러 메시지 매핑을 전용 헬퍼로 분리했습니다.
@MainActor
@Observable
final class PicCardRecordViewModel {
    private let createCardUseCase: CreateCardUseCase
    private let recordFlowVM: RecordFlowViewModel

    // UI 상태
    private(set) var isUploading = false
    private(set) var lastCreatedCardId: Int?
    private(set) var errorMessage: String?

    init(container: DIContainer, recordFlowVM: RecordFlowViewModel) {
        let provider = container.apiProviderStore.card()
        let repository = CardRepositoryImpl(provider: provider)
        self.createCardUseCase = CreateCardUseCaseImpl(repository: repository)
        self.recordFlowVM = recordFlowVM
    }

    /// PicCard 생성을 실행합니다. 중복 업로드를 방지하고, 완료 후 상태를 갱신합니다.
    /// - Important: `RecordFlowViewModel.state`를 스냅샷으로 읽어 사용합니다.
    func createPicCard() async {
        guard !isUploading else { return }
        isUploading = true
        defer { isUploading = false }
        
        errorMessage = nil
        lastCreatedCardId = nil

        do {
            let state = recordFlowVM.state
            let createCardRequestDTO = try CreateCardMapper.makeRequest(from: state)
            let cardId = try await createCardUseCase.execute(
                state: state,
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
