//
//  BadgeModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import SwiftUI

// MARK: - BadgeModel

/// 개별 배지의 정보를 담는 모델
struct BadgeModel: Identifiable {
    
    // MARK: - Properties
    
    /// 배지의 고유 id
    let id = UUID()
    
    /// 배지의 이름 (예: "혼밥러", "공유왕", "삼시세끼")
    let name: String
    
    /// 배지의 현재 상태 (progress, locked, completed)
    let state: BadgeState
    
    /// 배지에 대한 설명 텍스트
    let description: String
    
    // MARK: - Initializer
    
    /// 배지 모델을 초기화합니다
    /// - Parameters:
    ///   - name: 배지 이름
    ///   - state: 배지 상태
    ///   - description: 배지 설명 (기본값: 빈 문자열)
    init(
        name: String,
        state: BadgeState,
        description: String = ""
    ) {
        self.name = name
        self.state = state
        self.description = description
    }
}

// MARK: - BadgeStatusModel
/// 전체 배지 현황을 관리하는 모델 (사용자의 배지 획득 진행률과 전체 배지 목록을 관리)
struct BadgeStatusModel {
    
    // MARK: - Properties

    /// 전체 배지 개수
    let totalBadges: Int
    
    /// 획득한 배지 개수
    let earnedBadges: Int
    
    /// 모든 배지 정보를 담은 배열
    let badges: [BadgeModel]
    
    /// 배지 획득 진행률을 백분율로 계산
    /// - Returns: 0.0 ~ 1.0 사이의 진행률 (예: 0.3 = 30%)
    var progressPercentage: Double {
        guard totalBadges > 0 else { return 0 }
        return Double(earnedBadges) / Double(totalBadges)
    }
    
    /// - Parameters:
    ///   - totalBadges: 전체 배지 개수 (기본값: 10)
    ///   - earnedBadges: 획득한 배지 개수 (기본값: 0)
    ///   - badges: 배지 배열 (기본값: 빈 배열)
    init(
        totalBadges: Int = 10,
        earnedBadges: Int = 0,
        badges: [BadgeModel] = []
    ) {
        self.totalBadges = totalBadges
        self.earnedBadges = earnedBadges
        self.badges = badges
    }
}
