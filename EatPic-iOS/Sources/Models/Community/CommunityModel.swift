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
}

struct PicCard: Identifiable, Equatable {
    let id = UUID()
    let user: CommunityUser
    let time: String
    let image: Image
    let memo: String
    
    // MARK: - 스웨거 기반으로 추가된 속성들
    let imageUrl: String?
    let date: String
    let meal: String
    let recipe: String?
    let recipeUrl: URL?
    let latitude: Double?
    let longitude: Double?
    let locationText: String?
    let hashtags: [String]?
    let reactionCount: Int
    let userReaction: String?
    let commentCount: Int
    let bookmarked: Bool
}

struct Comment: Identifiable {
    let id = UUID()
    let user: CommunityUser
    let text: String
    let time: String
}

// MARK: - Sample Data

var sampleUsers: [CommunityUser] = [
    CommunityUser(id: "전체", nickname: "전체",
                  imageName: "Community/grid_selected", isCurrentUser: false, isFollowed: false),
    CommunityUser(id: "나", nickname: "나", imageName: nil, isCurrentUser: true, isFollowed: false),
    CommunityUser(id: "id1", nickname: "아이디1", imageName: nil,
                  isCurrentUser: false, isFollowed: true),
    CommunityUser(id: "id2", nickname: "아이디2", imageName: nil,
                  isCurrentUser: false, isFollowed: true),
    CommunityUser(id: "id3", nickname: "아이디3", imageName: nil,
                  isCurrentUser: false, isFollowed: true),
    CommunityUser(id: "id4", nickname: "아이디4", imageName: nil,
                  isCurrentUser: false, isFollowed: true),
    CommunityUser(id: "id5", nickname: "아이디5", imageName: nil,
                  isCurrentUser: false, isFollowed: true)
]

var sampleCards: [PicCard] = [
    PicCard(user: sampleUsers[1], time: "오후 6:30",
            image: Image("Community/testImage"), memo: "오늘은 샐러드를 먹었습니다~",
            imageUrl: nil, date: "2025-08-11", meal: "LUNCH",
            recipe: "UMC FS데이에 역삼까지 왔는데 샐러드 먹는 내 인생..",
            recipeUrl: URL(string: "https://recipe.example.com/salad-abc123"),
            latitude: 37.503456, longitude: 127.036524,
            locationText: "샐러드박스 역삼본점",
            hashtags: ["#점심", "#샐러드", "다이어트"], reactionCount: 123,
            userReaction: "YUMMY", commentCount: 3, bookmarked: true),
    PicCard(user: sampleUsers[2], time: "오후 7:20",
            image: Image("Community/testImage1"), memo: "파스타 먹음",
            imageUrl: nil, date: "2025-08-10",
            meal: "DINNER", recipe: "이 근처에서 가장 구글 평점 높았던 곳. 무려 4.8점",
            recipeUrl: URL(string: "https://recipe.example.com/salad-abc123"),
            latitude: 37.509311, longitude: 127.025866,
            locationText: "비스트로논현",
            hashtags: ["#알리오올리오", "#파스타"], reactionCount: 123,
            userReaction: "YUMMY", commentCount: 3, bookmarked: true),
    PicCard(user: sampleUsers[1], time: "오후 1:50",
            image: Image("Community/testImage2"), memo: "아침엔 스무디",
            imageUrl: nil, date: "2025-08-11",
            meal: "LUNCH", recipe: "예진이가 60프로 할인쿠폰을 적용해줬다",
            recipeUrl: URL(string: "https://recipe.example.com/salad-abc123"),
            latitude: 37.496321, longitude: 127.038893,
            locationText: "스타벅스 구역삼사거리점",
            hashtags: ["#아메리카노","#커피", "#스타벅스"], reactionCount: 123,
            userReaction: "YUMMY", commentCount: 3, bookmarked: true),
    PicCard(user: sampleUsers[3], time: "오후 2:00",
            image: Image("Community/testImage3"), memo: "오랜만에 피자!",
            imageUrl: nil, date: "2025-07-01",
            meal: "LUNCH", recipe: "레시피 설명...",
            recipeUrl: URL(string: "https://recipe.example.com/salad-abc123"),
            latitude: 37.12, longitude: 127.98,
            locationText: "캐나다라마바사아자차카파타하가나다라",
            hashtags: ["#아침", "#다섯글자"], reactionCount: 123,
            userReaction: "YUMMY", commentCount: 3, bookmarked: true),
    PicCard(user: sampleUsers[2], time: "오후 6:30",
            image: Image("Community/testImage"), memo: "오늘은 샐러드 먹음",
            imageUrl: nil, date: "2025-07-01",
            meal: "LUNCH", recipe: "레시피 설명...",
            recipeUrl: URL(string: "https://recipe.example.com/salad-abc123"),
            latitude: 37.12, longitude: 127.98,
            locationText: "캐나다라마바사아자차카파타하가나다라",
            hashtags: ["#아침", "#다섯글자"], reactionCount: 123,
            userReaction: "YUMMY", commentCount: 3, bookmarked: true),
    PicCard(user: sampleUsers[2], time: "오후 3:10",
            image: Image("Community/testImage2"), memo: "아침엔 스무디 먹음",
            imageUrl: nil, date: "2025-07-01",
            meal: "LUNCH", recipe: "레시피 설명...",
            recipeUrl: URL(string: "https://recipe.example.com/salad-abc123"),
            latitude: 37.12, longitude: 127.98,
            locationText: "캐나다라마바사아자차카파타하가나다라",
            hashtags: ["#아침", "#다섯글자"], reactionCount: 123,
            userReaction: "YUMMY", commentCount: 3, bookmarked: true),
    PicCard(user: sampleUsers[2], time: "오후 2:00",
            image: Image("Community/testImage3"), memo: "오랜만에 피자 먹음",
            imageUrl: nil, date: "2025-07-01",
            meal: "LUNCH", recipe: "레시피 설명...",
            recipeUrl: URL(string: "https://recipe.example.com/salad-abc123"),
            latitude: 37.12, longitude: 127.98,
            locationText: "캐나다라마바사아자차카파타하가나다라",
            hashtags: ["#아침", "#다섯글자"], reactionCount: 123,
            userReaction: "YUMMY", commentCount: 3, bookmarked: true)
]

var sampleComments: [Comment] = [
    Comment(user: sampleUsers[1], text: "정말 맛있어 보이네요! 🤤", time: "10분 전"),
    Comment(user: sampleUsers[2], text: "어디서 먹을 수 있나요?", time: "5분 전"),
    Comment(user: sampleUsers[3], text: "레시피 공유해주세요~", time: "1분 전"),
    Comment(user: sampleUsers[4], text: "바로 저장", time: "1분 전"),
    Comment(user: sampleUsers[5], text: "내일 가봐야지", time: "1분 전")
]

let reportTypes = [
    "욕설 또는 비방",
    "음란성/선정적 내용",
    "도배 또는 광고성 게시물",
    "거짓 정보 또는 허위 사실",
    "불쾌감을 주는 이미지 또는 언행",
    "저작권 침해"
]
