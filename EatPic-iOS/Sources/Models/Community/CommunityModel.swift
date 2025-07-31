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

// MARK: - Sample Data

let sampleUsers: [CommunityUser] = [
    CommunityUser(id: "전체", nickname: "전체",
                  imageName: "Community/grid_selected", isCurrentUser: false),
    CommunityUser(id: "나", nickname: "나", imageName: nil, isCurrentUser: true),
    CommunityUser(id: "id1", nickname: "아이디1", imageName: nil, isCurrentUser: false),
    CommunityUser(id: "id2", nickname: "아이디2", imageName: nil, isCurrentUser: false),
    CommunityUser(id: "id3", nickname: "아이디3", imageName: nil, isCurrentUser: false)
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
