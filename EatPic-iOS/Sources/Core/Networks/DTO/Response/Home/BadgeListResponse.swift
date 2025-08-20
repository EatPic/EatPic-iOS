//
//  BadgeListResponse.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/19/25.
//

import Foundation

/// 홈화면 사용자 뱃지리스트 조회 응답 구조체
struct BadgeListResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [BadgeListResult]
}
    
struct BadgeListResult: Codable {
    let userBadgeId: Int
    let badgeName: String
    let badgeImageUrl: String
    let progressRate: Int
    let achieved: Bool
}
