//
//  CommunityModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/30/25.
//

import Foundation
import SwiftUI

// MARK: - Models

struct CommunityUser: Identifiable, Hashable, Equatable {
    let id: String
    let nickname: String
    let imageName: String?
    var profileImage: Image? {
        imageName.map { Image($0) }
    }
    let isCurrentUser: Bool
    var isFollowed: Bool
    
    // FeedUser를 받아서 CommunityUser를 생성하는 이니셜라이저 추가
    init(from feedUser: FeedUser) {
        self.id = String(feedUser.userId) // Int 타입의 userId를 String으로 변환
        self.nickname = feedUser.nickname
        self.imageName = feedUser.profileImageUrl // profileImageUrl을 imageName에 할당
        self.isCurrentUser = false // API 응답에 없는 속성이므로 기본값 설정
        self.isFollowed = false    // API 응답에 없는 속성이므로 기본값 설정
    }
}

struct PicCard: Identifiable, Equatable {
    let id = UUID()
    let cardId: Int
    let user: CommunityUser
    let time: String
    let memo: String
    
    // MARK: - 스웨거 기반으로 추가된 속성들
    let imageUrl: String
    let date: String
    let meal: MealSlot
    let recipe: String?
    let recipeUrl: URL?
    let latitude: Double?
    let longitude: Double?
    let locationText: String?
    let hashtags: [String]?
    
    // MARK: - 동적으로 변경 가능한 상태 속성들
    var reactionCount: Int
    var userReaction: String?
    var commentCount: Int
    var bookmarked: Bool
    
    // Feed를 받아서 PicCard를 생성하는 이니셜라이저 추가
    init(from feed: Feed) {
        self.cardId = feed.cardId
        self.user = CommunityUser(from: feed.user) // FeedUser를 CommunityUser로 변환
        self.time = feed.time
        self.imageUrl = feed.imageUrl
        self.memo = feed.memo
        self.date = feed.date
        self.meal = feed.meal
        self.recipe = feed.recipe
        // String을 URL로 변환
        self.recipeUrl = URL(string: feed.recipeUrl ?? "")
        self.latitude = feed.latitude
        self.longitude = feed.longitude
        self.locationText = feed.locationText
        self.hashtags = feed.hashtags
        self.reactionCount = feed.reactionCount
        self.userReaction = feed.userReaction
        self.commentCount = feed.commentCount
        self.bookmarked = feed.bookmarked
    }
    // 북마크 상태 토글
    mutating func toggleBookmark() {
        bookmarked.toggle()
    }
    
    // 리액션 업데이트
    mutating func updateReaction(newReaction: String?, newCount: Int) {
        userReaction = newReaction
        reactionCount = newCount
    }
    
    // 댓글 수 업데이트
    mutating func updateCommentCount(_ newCount: Int) {
        commentCount = newCount
    }
    
    // Equatable을 위한 비교 메서드
    static func == (lhs: PicCard, rhs: PicCard) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Comment: Identifiable {
    let id = UUID()
    let user: CommunityUser
    let text: String
    let time: String
}

// MARK: - Sample Data
// 더미 FeedUser 데이터
let dummyFeedUser1 = FeedUser(userId: 1, nickname: "홍길동",
                              profileImageUrl: "https://example.com/profiles/hong.jpg")
let dummyFeedUser2 = FeedUser(userId: 2, nickname: "김영희",
                              profileImageUrl: "https://example.com/profiles/young.jpg")
let dummyFeedUser3 = FeedUser(userId: 3, nickname: "박민수",
                              profileImageUrl: "https://example.com/profiles/minsu.jpg")

let sampleUsers: [CommunityUser] = [
    CommunityUser(from: dummyFeedUser1),
    CommunityUser(from: dummyFeedUser2),
    CommunityUser(from: dummyFeedUser3)
]

// 더미 Feed 데이터
let dummyFeed1 = Feed(
    cardId: 1,
    imageUrl: "https://example.com/images/Community/testImage.jpg",
    date: "2025-08-11",
    time: "오후 6:30",
    meal: .LUNCH,
    memo: "오늘은 샐러드를 먹었습니다~",
    recipe: "UMC FS데이에 역삼까지 왔는데 샐러드 먹는 내 인생..",
    recipeUrl: "https://recipe.example.com/salad-abc123",
    latitude: 37.503456,
    longitude: 127.036524,
    locationText: "샐러드박스 역삼본점",
    hashtags: ["#점심", "#샐러드", "#다이어트"],
    user: dummyFeedUser1,
    reactionCount: 12,
    userReaction: "YUMMY",
    commentCount: 7,
    bookmarked: true
)

let dummyFeed2 = Feed(
    cardId: 2,
    imageUrl: "https://example.com/images/Community/testImage1.jpg",
    date: "2025-08-10",
    time: "오후 7:20",
    meal: .DINNER,
    memo: "파스타 먹음",
    recipe: "이 근처에서 가장 구글 평점 높았던 곳. 무려 4.8점",
    recipeUrl: "https://recipe.example.com/salad-abc123",
    latitude: 37.509311,
    longitude: 127.025866,
    locationText: "비스트로논현",
    hashtags: ["#알리오올리오", "#파스타"],
    user: dummyFeedUser2,
    reactionCount: 23,
    userReaction: "YUMMY",
    commentCount: 3,
    bookmarked: true
)

let dummyFeed3 = Feed(
    cardId: 3,
    imageUrl: "https://example.com/images/Community/testImage2.jpg",
    date: "2025-08-11",
    time: "오후 1:50",
    meal: .BREAKFAST,
    memo: "아침엔 스무디",
    recipe: "예진이가 60프로 할인쿠폰을 적용해줬다",
    recipeUrl: "https://recipe.example.com/salad-abc123",
    latitude: 37.496321,
    longitude: 127.038893,
    locationText: "스타벅스 구역삼사거리점",
    hashtags: ["#아메리카노", "#커피", "#스타벅스"],
    user: dummyFeedUser1,
    reactionCount: 3,
    userReaction: "YUMMY",
    commentCount: 3,
    bookmarked: true
)

let dummyFeed4 = Feed(
    cardId: 4,
    imageUrl: "https://example.com/images/Community/testImage3.jpg",
    date: "2025-07-01",
    time: "오후 2:00",
    meal: .LUNCH,
    memo: "오랜만에 피자!",
    recipe: "레시피 설명...",
    recipeUrl: "https://recipe.example.com/salad-abc123",
    latitude: 37.12,
    longitude: 127.98,
    locationText: "피자헛",
    hashtags: ["#아침", "#피자"],
    user: dummyFeedUser3,
    reactionCount: 13,
    userReaction: "YUMMY",
    commentCount: 5,
    bookmarked: true
)

let dummyFeed5 = Feed(
    cardId: 5,
    imageUrl: "https://example.com/images/Community/testImage.jpg",
    date: "2025-07-01",
    time: "오후 6:30",
    meal: .LUNCH,
    memo: "오늘은 샐러드 먹음",
    recipe: "샐러드 만드는 법",
    recipeUrl: "https://recipe.example.com/salad-abc123",
    latitude: nil,
    longitude: nil,
    locationText: nil,
    hashtags: ["#아침", "#다섯글자"],
    user: dummyFeedUser2,
    reactionCount: 9,
    userReaction: "YUMMY",
    commentCount: 3,
    bookmarked: true
)

let dummyFeed6 = Feed(
    cardId: 6,
    imageUrl: "https://example.com/images/Community/testImage2.jpg",
    date: "2025-07-01",
    time: "오후 3:10",
    meal: .BREAKFAST,
    memo: "아침엔 스무디 먹음",
    recipe: nil,
    recipeUrl: nil,
    latitude: nil,
    longitude: nil,
    locationText: nil,
    hashtags: ["#아침", "#다섯글자"],
    user: dummyFeedUser2,
    reactionCount: 1,
    userReaction: "YUMMY",
    commentCount: 4,
    bookmarked: true
)

let dummyFeed7 = Feed(
    cardId: 7,
    imageUrl: "https://example.com/images/Community/testImage3.jpg",
    date: "2025-07-01",
    time: "오후 2:00",
    meal: .DINNER,
    memo: "오랜만에 피자 먹음",
    recipe: "레시피 설명...",
    recipeUrl: "https://recipe.example.com/salad-abc123",
    latitude: 37.12,
    longitude: 127.98,
    locationText: "캐나다라마바사아자차카파타하가나다라",
    hashtags: ["#아침", "#다섯글자"],
    user: dummyFeedUser2,
    reactionCount: 0,
    userReaction: "YUMMY",
    commentCount: 1,
    bookmarked: true
)

// MARK: - 수정된 PicCard 더미 데이터 (from: Feed)
var sampleCards: [PicCard] = [
    PicCard(from: dummyFeed1),
    PicCard(from: dummyFeed2),
    PicCard(from: dummyFeed3),
    PicCard(from: dummyFeed4),
    PicCard(from: dummyFeed5),
    PicCard(from: dummyFeed6),
    PicCard(from: dummyFeed7)
]
var sampleComments: [Comment] = [
    Comment(user: dummyUser, text: "정말 맛있어 보이네요! 🤤", time: "10분 전"),
    Comment(user: dummyUser, text: "어디서 먹을 수 있나요?", time: "5분 전"),
    Comment(user: dummyUser, text: "레시피 공유해주세요~", time: "1분 전"),
    Comment(user: dummyUser, text: "바로 저장", time: "1분 전"),
    Comment(user: dummyUser, text: "내일 가봐야지", time: "1분 전")
]

let reportTypes = [
    "욕설 또는 비방",
    "음란성/선정적 내용",
    "도배 또는 광고성 게시물",
    "거짓 정보 또는 허위 사실",
    "불쾌감을 주는 이미지 또는 언행",
    "저작권 침해"
]

let dummyFeedUser = FeedUser(
    userId: 98765,
    nickname: "원주연",
    profileImageUrl: "https://example.com/images/profile_ju_yeon.jpg"
)
let dummyUser = CommunityUser(from: dummyFeedUser)
