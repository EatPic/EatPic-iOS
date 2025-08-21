//
//  CommunityModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/30/25.
//

import Foundation
import SwiftUI

// MARK: - Models

//struct CommunityUser: Identifiable, Hashable, Equatable {
//    let id: Int
//    let nameId: String
//    let nickname: String
//    let imageName: String?
//    var profileImage: Image? {
//        imageName.map { Image($0) }
//    }
//    let introduce: String?
//    let userType: CommunityUserType
//    let isCurrentUser: Bool
//    var isFollowed: Bool
//    
//    init(id: Int, nameId: String, nickname: String,
//         imageName: String?, introduce: String? = nil,
//         type: CommunityUserType = .other,
//         isCurrentUser: Bool = false,
//         isFollowed: Bool = true) {
//        self.id = id
//        self.nameId = nameId
//        self.nickname = nickname
//        self.imageName = imageName
//        self.introduce = introduce
//        self.userType = type
//        self.isCurrentUser = isCurrentUser
//        self.isFollowed = isFollowed
//    }
//}
//
//enum CommunityUserType {
//    case all
//    case me
//    case other
//}
//
//struct PicCard: Identifiable, Equatable {
//    let id = UUID()
//    let cardId: Int
//    let user: CommunityUser
//    let time: String
//    let memo: String
//    
//    // MARK: - 스웨거 기반으로 추가된 속성들
//    let imageUrl: String
//    let date: String
//    let meal: MealSlot
//    let recipe: String?
//    let recipeUrl: URL?
//    let latitude: Double?
//    let longitude: Double?
//    let locationText: String?
//    let hashtags: [String]?
//    
//    // MARK: - 동적으로 변경 가능한 상태 속성들
//    var reactionCount: Int
//    var userReaction: String?
//    var commentCount: Int
//    var bookmarked: Bool
//    
//    // 북마크 상태 토글
//    mutating func toggleBookmark() {
//        bookmarked.toggle()
//    }
//    
//    // 리액션 업데이트
//    mutating func updateReaction(newReaction: String?, newCount: Int) {
//        userReaction = newReaction
//        reactionCount = newCount
//    }
//    
//    // 댓글 수 업데이트
//    mutating func updateCommentCount(_ newCount: Int) {
//        commentCount = newCount
//    }
//    
//    // Equatable을 위한 비교 메서드
//    static func == (lhs: PicCard, rhs: PicCard) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
//
//struct Comment: Identifiable {
//    let id: Int
//    let user: CommunityUser
//    let text: String
//    let time: String
//}
