//
//  ProfileDetailResult.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/21/25.
//

import Foundation

// 프로필 상세 응답
struct ProfileDetailResult: Codable {
    let userId: Int
    let profileImageUrl: String?
    let nameId: String
    let nickname: String
    let isFollowing: Bool
    let introduce: String?
    let totalCard: Int
    let totalFollower: Int
    let totalFollowing: Int
}
