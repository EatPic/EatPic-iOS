//
//  UserIconResponse.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/19/25.
//

import Foundation

// Communtiy탭 상단 팔로잉하는 유저 아이콘을 띄우기 위한 응답구조체 (팔로잉하는 유저들, 나)

// 팔로잉하는 유저들을 불러오기 위한 응답구조체
struct UserListResult: Codable {
    let page: Int
    let size: Int
    let total: Int
    let userIconList: [UserIconDTO]
}

// 팔로잉하는 유저들 정보
struct UserIconDTO: Codable, Identifiable {
    let userId: Int
    let profileImageUrl: String
    let nameId: String
    let nickname: String
    let introduce: String
    let isFollowing: Bool?

    // SwiftUI ForEach 등에서 사용하기 위해 id 프로퍼티 추가
    var id: Int { userId }
}

// API -> UserIcon 변환로직
extension UserIconDTO {
    func toCommunityUser() -> CommunityUser {
        CommunityUser(
            id: userId,
            nameId: nameId,
            nickname: nickname,
            imageName: profileImageUrl
        )
    }
}

// 나의 아이콘을 불러오기 위한 응답구조체
struct MyUserIconResult: Codable, Identifiable {
    let userId: Int
    let profileImageUrl: String?
    let nameId: String
    let nickname: String
    let introduce: String?
    let isFollowing: Bool?
    
    var id: Int { userId }
}

// API -> UserIcon 변환로직
extension MyUserIconResult {
    func toCommunityUser() -> CommunityUser {
        CommunityUser(
            id: userId,
            nameId: nameId,
            nickname: nickname,
            imageName: profileImageUrl,
            introduce: introduce,
            type: .me,
            isCurrentUser: true,
            isFollowed: false
        )
    }
}
