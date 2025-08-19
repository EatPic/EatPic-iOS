//
//  ReactionTargetType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/19/25.
//

import Foundation
import Moya

enum ReactionTargetType {
    case postReaction(cardId: Int, reactionType: ReactionTypes)
}

extension ReactionTargetType: APITargetType {
    var path: String {
        switch self {
        case .postReaction(let cardId, let reactionType):
            return "/api/reactions/\(cardId)/\(reactionType)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postReaction:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postReaction:
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
