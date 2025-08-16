//
//  CardTargetType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/13/25.
//

import Foundation
import Moya

/// 식사 기록 요청 DTO
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

/// 서버 공통 응답 래핑
struct CreateCardResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CreateCardResult
}

/// 카드 생성 결과 (필요한 필드만)
struct CreateCardResult: Decodable {
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

enum MultipartField {
    static let cardImage = "cardImageFile"
    static let request = "request"
}

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
        let repository = DefaultCardRepository(provider: provider)
        self.createCardUseCase = DefaultCreateCardUseCase(repository: repository)
        self.recordFlowVM = recordFlowVM
    }

    func createPicCard() async {
        guard !isUploading else { return }
        isUploading = true
        errorMessage = nil
        lastCreatedCardId = nil

        do {
            let state = recordFlowVM.state
            let createCardRequestDTO = try recordFlowVM.getCreateCardRequestDTO()
            let cardId = try await createCardUseCase.execute(
                state: state,
                request: createCardRequestDTO
            )
            self.lastCreatedCardId = cardId
        } catch let err as UploadError {
            switch err {
            case .missingImage:
                self.errorMessage = "업로드할 이미지를 선택해주세요."
            case .encodingFailed:
                self.errorMessage = "이미지 인코딩에 실패했습니다. 다시 시도해주세요."
            case .invalidServerResponse:
                self.errorMessage = "서버 응답이 올바르지 않습니다."
            case .networkError(let underlying):
                self.errorMessage = "네트워크 오류: \(underlying.localizedDescription)"
            }
        } catch let err as MoyaError {
            // 네트워크 레이어에서 직접 던져진 경우
            switch err {
            case .underlying(let nsError, _):
                self.errorMessage = "네트워크 오류: \(nsError.localizedDescription)"
            case .statusCode(let response):
                self.errorMessage = "요청이 실패했습니다(\(response.statusCode))."
            default:
                self.errorMessage = "요청 처리 중 오류가 발생했습니다."
            }
        } catch let err as APIError {
            if case let .serverError(code, msg) = err {
                self.errorMessage = err.errorDescription
            }
            else if case .decodingFailed = err {
                self.errorMessage = err.errorDescription
            }
        } catch {
            self.errorMessage = "알 수 없는 오류가 발생했습니다."
        }
        self.isUploading = false
    }
}
