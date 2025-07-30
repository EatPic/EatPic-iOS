//
//  CommunityModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/30/25.
//

import Foundation
import SwiftUI

// MARK: - Models

struct CommunityUser: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let profileImage: Image?
    let isCurrentUser: Bool
}

struct PicCard: Identifiable {
    let id = UUID()
    let user: CommunityUser
    let time: String
    let image: Image
    let memo: String
}

// MARK: - Sample Data

let sampleUsers: [CommunityUser] = [
    CommunityUser(name: "전체", profileImage: Image("Community/grid_selected"), isCurrentUser: false),
    CommunityUser(name: "나", profileImage: nil, isCurrentUser: true),
    CommunityUser(name: "아이디1", profileImage: nil, isCurrentUser: false),
    CommunityUser(name: "아이디2", profileImage: nil, isCurrentUser: false),
    CommunityUser(name: "아이디3", profileImage: nil, isCurrentUser: false)
]

let sampleCards: [PicCard] = [
    PicCard(user: sampleUsers[1], time: "오후 6:30",
            image: Image("Community/testImage"), memo: "오늘은 샐러드를 먹었습니다~"),
    PicCard(user: sampleUsers[2], time: "오후 5:20",
            image: Image("Community/testImage1"), memo: "파스타 먹음"),
    PicCard(user: sampleUsers[1], time: "오후 3:10",
            image: Image("Community/testImage2"), memo: "아침엔 스무디"),
    PicCard(user: sampleUsers[3], time: "오후 2:00",
            image: Image("Community/testImage3"), memo: "오랜만에 피자!")
]
