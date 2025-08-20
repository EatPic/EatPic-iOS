//
//  BadgeDetailDescDTO.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/20/25.
//

import Foundation

// 상세 응답에서 description만 쓰는 DTO
struct BadgeDetailDescDTO: Codable {
    let userBadgeId: Int
    let badgeDescription: String
}
