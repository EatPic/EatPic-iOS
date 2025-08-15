//
//  CardFeedResponse.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/13/25.
//

import Foundation
import Moya

// MARK: - API Response

struct FeedResult: Codable {
    let selectedId: Int
    let hasNext: Bool
    let nextCursor: Int?
    let cardFeedList: [Feed]
}

// MARK: - Card Feed Item
struct Feed: Codable {
    let cardId: Int
    let imageUrl: String?
    let datetime: String
    let meal: MealSlot
    let memo: String
    let recipe: String?
    let recipeUrl: String?
    let latitude: Double?
    let longitude: Double?
    let locationText: String?
    let hashtags: [String]
    let user: FeedUser
    let reactionCount: Int
    let userReaction: String?
    let commentCount: Int
    let bookmarked: Bool
    
    // MARK: - Date / Time 포매팅
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        if let date = formatter.date(from: datetime) {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: date)
        }
        return datetime
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 서버 datetime 형식
        formatter.locale = Locale(identifier: "ko_KR")
        
        if let date = formatter.date(from: datetime) {
            formatter.dateFormat = "a hh:mm" // 오전/오후 표시 포함
            return formatter.string(from: date)
        }
        return ""
    }
}

// MARK: - User Info
struct FeedUser: Codable {
    let userId: Int
    let nameId: String
    let nickname: String
    let profileImageUrl: String
}
