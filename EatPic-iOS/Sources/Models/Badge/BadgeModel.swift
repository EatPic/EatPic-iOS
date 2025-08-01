//
//  BadgeModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import SwiftUI

/// 뱃지 정보를 담는 모델
struct BadgeModel: Identifiable {
    let id = UUID()
    let name: String
    let state: BadgeState
    let description: String
    
    init(name: String, state: BadgeState, description: String = "") {
        self.name = name
        self.state = state
        self.description = description
    }
}

/// 뱃지 상태 정보를 담는 모델
struct BadgeStatusModel {
    let totalBadges: Int
    let earnedBadges: Int
    let badges: [BadgeModel]
    
    var progressPercentage: Double {
        guard totalBadges > 0 else { return 0 }
        return Double(earnedBadges) / Double(totalBadges)
    }
    
    init(totalBadges: Int = 10, earnedBadges: Int = 0, badges: [BadgeModel] = []) {
        self.totalBadges = totalBadges
        self.earnedBadges = earnedBadges
        self.badges = badges
    }
} 