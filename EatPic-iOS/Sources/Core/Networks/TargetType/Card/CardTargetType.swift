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
}

extension CardTargetType: APITargetType {
    var path: String {
        switch self {
        case .fetchFeeds:
            return "/api/cards/feeds"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFeeds:
            return .get
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
        }
    }
    
    var sampleData: Data {
        return Data("""
         {
           "isSuccess": true,
           "code": "string",
           "message": "string",
           "result": [
             {
               "date": "2025-08-02",
               "imageUrl": "https://example.com/image.jpg",
               "cardId": 123
             }
           ]
         }
        """.utf8)
    }
}
