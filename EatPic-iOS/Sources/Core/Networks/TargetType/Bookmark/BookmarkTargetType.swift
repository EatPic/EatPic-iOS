//
//  BookmarkTargetType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/19/25.
//

import Foundation
import Moya

/// 북마크 저장/삭제를 위한 API를 정의하는 TargetType입니다.
enum BookmarkTargetType {
    case postBookmark(cardId: Int)
}

extension BookmarkTargetType: APITargetType {
    var path: String {
        switch self {
        case .postBookmark(let cardId):
            return "api/bookmarks/\(cardId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postBookmark:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .postBookmark:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        return Data("""
                {
                    "user_id": 1,
                    "token": "jwt-token"
                }
                """.utf8)
    }
}
