//
//  CardTargetType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/13/25.
//

import Foundation
import Moya

enum CardTargetType {
    case fetchFeeds(userId: Int, cursor: Int?, size: Int)
    case fetchCardDetail(cardId: Int)
    case createFeed(
        request: CreateCardRequest, image: Data, fileName: String, mimeType: String)
    case deleteCard(cardId: Int)
    case recommendedCard
    case todayMeals
}

extension CardTargetType: APITargetType {
    var path: String {
        switch self {
        case .fetchFeeds:
            return "/api/cards/feeds"
        case .fetchCardDetail(let cardId):
            return "/api/cards/\(cardId)/feed"
        case .createFeed:
            return "/api/cards"
        case .deleteCard(let cardId):
            return "/api/cards/\(cardId)"
        case .recommendedCard:
            return "/api/cards/recommended-cards"
        case .todayMeals:
            return "/api/cards/home/today-cards"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFeeds, .recommendedCard, .todayMeals, .fetchCardDetail:
            return .get
        case .createFeed:
            return .post
        case .deleteCard:
            return .delete
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
        case .fetchCardDetail(let cardId):
            return .requestPlain
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
        case .deleteCard:
            return .requestPlain
            
        case .recommendedCard, .todayMeals:
            return .requestPlain
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
