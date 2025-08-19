//
//  SingleCardFeed.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/19/25.
//

import Foundation
import Moya

struct SingleCardFeedResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SingleCardFeedResult
}

struct SingleCardFeedResult: Codable {
    let cardId: Int
    let imageUrl: String
    let datetime: String
    let meal: MealSlot
    let memo: String
    let recipe: String
    let recipeUrl: String?
    let latitude: Double?
    let longitude: Double?
    let locationText: String?
    let hashtags: [String]?
    let user: SingleCardFeedUser
    let reactionCount: Int
    let userReaction: String?
    let commentCount: Int
    let bookmarked: Bool
}

// MARK: - PicCard 변환
extension SingleCardFeedResult {
    func toPicCard() -> PicCard {
        // user 변환 먼저
        let user = user.toCommunityUser()
        
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
            user: user,
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

struct SingleCardFeedUser: Codable {
    let userId: Int
    let nameId: String
    let nickname: String
    let profileImageUrl: String
}

extension SingleCardFeedUser {
    func toCommunityUser() -> CommunityUser {
        CommunityUser(
            id: userId,
            nameId: nameId,
            nickname: nickname,
            imageName: profileImageUrl
        )
    }
}
