//
//  CommentTargetType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/20/25.
//

import Foundation
import Moya

/// 댓글 관리를 위한 API를 정의하는 TargetType입니다.
enum CommentTargetType {
    case postComment(cardId: Int, request: CommentRequest)
}

extension CommentTargetType: APITargetType {
    var path: String {
        switch self {
        case .postComment(let cardId, _):
            return "api/comments/\(cardId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postComment:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .postComment(_, let request):
            return .requestJSONEncodable(request)
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
