//
//  CardTargetType.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/14/25.
//

import Foundation
import Moya

enum CardTargetType {
    case fetchRecommendedCards
}

extension CardTargetType: APITargetType {
    var path: String {
        switch self {
        case .fetchRecommendedCards:
            return "/api/cards/recommended-cards"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchRecommendedCards:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchRecommendedCards:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchRecommendedCards:
            return Data("""
                {
                  "isSuccess": true,
                  "code": "string",
                  "message": "string",
                  "result": [
                    {
                      "cardId": 12,
                      "cardImageUrl": "https://cdn.eatpic.com/cards/12.jpg"
                    }
                  ]
                }
            """.utf8)
        }
    }
}
