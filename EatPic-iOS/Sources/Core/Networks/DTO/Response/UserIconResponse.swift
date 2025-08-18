//
//  UserIconResponse.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/19/25.
//

import Foundation

// Communtiy탭 상단 팔로잉하는 유저 아이콘을 띄우기 위한 응답구조체
// result 영역
struct UserIconResult: Codable {
    let page: Int
    let size: Int
    let total: Int
    let userIconList: [UserIcon]
}

// 실제 유저 정보
struct UserIcon: Codable, Identifiable {
    let userId: Int
    let profileImageUrl: String
    let nameId: String
    let nickname: String
    let introduce: String
    let isFollowing: Bool?

    // SwiftUI ForEach 등에서 사용하기 위해 id 프로퍼티 추가
    var id: Int { userId }
}

// 나의 아이콘을 불러오기 위한 응답구조체
struct MyIcon: Codable, Identifiable {
    let userId: Int
    let profileImageUrl: String
    let nameId: String
    let nickname: String
    let introduce: String
    let isFollowing: Bool
    
    var id: Int { userId }
}
