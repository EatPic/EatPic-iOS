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
    let uuid = UUID()
    let id: String
    let nickname: String
    let imageName: String?
    var profileImage: Image? {
        imageName.map { Image($0) }
    }
    let isCurrentUser: Bool
}

struct PicCard: Identifiable {
    let id = UUID()
    let user: CommunityUser
    let time: String
    let image: Image
    let memo: String
}

struct Comment: Identifiable {
    let id = UUID()
    let user: CommunityUser
    let text: String
    let time: String
}

// MARK: - Sample Data

let sampleUsers: [CommunityUser] = [
    CommunityUser(id: "전체", nickname: "전체",
                  imageName: "Community/grid_selected", isCurrentUser: false),
    CommunityUser(id: "나", nickname: "나", imageName: nil, isCurrentUser: true),
    CommunityUser(id: "id1", nickname: "아이디1", imageName: nil, isCurrentUser: false),
    CommunityUser(id: "id2", nickname: "아이디2", imageName: nil, isCurrentUser: false),
    CommunityUser(id: "id3", nickname: "아이디3", imageName: nil, isCurrentUser: false),
    CommunityUser(id: "id4", nickname: "아이디4", imageName: nil, isCurrentUser: false),
    CommunityUser(id: "id5", nickname: "아이디5", imageName: nil, isCurrentUser: false)
]

let sampleCards: [PicCard] = [
    PicCard(user: sampleUsers[1], time: "오후 6:30",
            image: Image("Community/testImage"), memo: "오늘은 샐러드를 먹었습니다~"),
    PicCard(user: sampleUsers[2], time: "오후 5:20",
            image: Image("Community/testImage1"), memo: "파스타 먹음"),
    PicCard(user: sampleUsers[1], time: "오후 3:10",
            image: Image("Community/testImage2"), memo: "아침엔 스무디"),
    PicCard(user: sampleUsers[3], time: "오후 2:00",
            image: Image("Community/testImage3"), memo: "오랜만에 피자!"),
    PicCard(user: sampleUsers[2], time: "오후 6:30",
            image: Image("Community/testImage"), memo: "오늘은 샐러드 먹음"),
    PicCard(user: sampleUsers[2], time: "오후 3:10",
            image: Image("Community/testImage2"), memo: "아침엔 스무디 먹음"),
    PicCard(user: sampleUsers[2], time: "오후 2:00",
            image: Image("Community/testImage3"), memo: "오랜만에 피자 먹음"),
]

let sampleComments: [Comment] = [
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
