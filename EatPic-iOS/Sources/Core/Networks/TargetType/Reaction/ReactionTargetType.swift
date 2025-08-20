//
//  ReactionTargetType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/19/25.
//

import Foundation
import Moya

enum ReactionTargetType {
    case postReaction(cardId: Int, reactionType: String)
    case getReactionUsers(cardId: Int, reactionType: ReactionType, page: Int, size: Int)
}

extension ReactionTargetType: APITargetType {
    var path: String {
        switch self {
        case .postReaction(let cardId, let reactionType):
            return "/api/reactions/\(cardId)/\(reactionType)"
        case .getReactionUsers(let cardId, let reactionType, _, _):
            return "/api/reactions/\(cardId)/\(reactionType)/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postReaction:
            return .post
        case .getReactionUsers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postReaction(let cardId, let reactionType):
            return .requestPlain
        case .getReactionUsers(_, _, let page, let size):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "size": size
                ],
                encoding: URLEncoding.queryString
            )
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

