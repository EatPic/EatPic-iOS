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
}

// MARK: - Feed → PicCard 변환
extension Feed {
    func toPicCard() -> PicCard {
        // user 변환 먼저
        let communityUser = user.toCommunityUser()
        
        // datetime 포맷팅
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        var formattedTime = ""
        var formattedDate = ""
        
        if let dateObj = formatter.date(from: datetime) {
            // 시간 (오전/오후 포함)
            formatter.dateFormat = "a hh:mm"
            formattedTime = formatter.string(from: dateObj)
            
            // 날짜 (YYYY-MM-DD)
            formatter.dateFormat = "yyyy-MM-dd"
            formattedDate = formatter.string(from: dateObj)
        }
        
        return PicCard(
            cardId: cardId,
            user: communityUser,
            time: formattedTime,
            memo: memo,
            imageUrl: imageUrl ?? "",
            date: formattedDate,
            meal: meal,
            recipe: recipe,
            recipeUrl: recipeUrl.flatMap { URL(string: $0) },
            latitude: latitude,
            longitude: longitude,
            locationText: locationText,
            hashtags: hashtags,
            reactionCount: reactionCount,
            userReaction: userReaction,
            commentCount: commentCount,
            bookmarked: bookmarked
        )
    }
}


// MARK: - User Info
struct FeedUser: Codable {
    let userId: Int
    let nameId: String
    let nickname: String
    let profileImageUrl: String?
}

extension FeedUser {
    func toCommunityUser() -> CommunityUser {
        CommunityUser(
            id: userId,
            nameId: nameId,
            nickname: nickname,
            imageName: profileImageUrl,
            introduce: nil,
            type: .other,
            isCurrentUser: false,
            isFollowed: true
        )
    }
}
