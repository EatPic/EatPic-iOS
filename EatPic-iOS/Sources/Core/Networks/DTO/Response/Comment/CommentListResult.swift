//
//  CommentListResult.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/20/25.
//

import Foundation

struct CommentListResult: Codable {
    let cardFeedList: [CardFeedItem]
    let hasNext: Bool
    let nextCursor: Int?
}

struct CardFeedItem: Codable {
    let cardFeedId: Int
    let user: CommentUser
    let content: String
    let createdAt: String
    let imageUrl: String
    let likeCount: Int
    let commentCount: Int
    let isLiked: Bool
    let latitude: Double
    let longitude: Double
}

struct CommentUser: Codable {
    let userId: Int
    let nameId: String
    let nickname: String
    let profileImageUrl: String
}
