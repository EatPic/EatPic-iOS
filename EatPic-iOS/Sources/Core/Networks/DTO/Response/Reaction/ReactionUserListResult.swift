//
//  ReactionUserListResult.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/20/25.
//
import Foundation

struct ReactionUserListResult: Codable {
    let cardId: Int
    let reactionType: ReactionType
    let page: Int
    let size: Int
    let total: Int
    let userList: [ReactionUser]
}

struct ReactionUser: Codable, Identifiable {
    let userId: Int
    let profileImageUrl: String
    let nameId: String
    let nickname: String
    let introduce: String
    let isFollowing: Bool
    
    var id: Int { userId }
}
