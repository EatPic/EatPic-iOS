//
//  BadgeGridViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import SwiftUI

/// 뱃지 그리드 화면의 ViewModel
@Observable
class BadgeGridViewModel {
    
    // MARK: - Property
    
    /// 사용자 닉네임
    let userNickname = "잇콩"
    
    /// 모든 뱃지 데이터
    var badges: [BadgeData] = []
    
    // MARK: - Computed Properties
    
    /// 완료된 뱃지 개수 (progress가 10인 경우)
    var completedBadgeCount: Int {
        return badges.filter { $0.progress == 10 }.count
    }
    
    /// 전체 뱃지 개수
    var totalBadgeCount: Int {
        return badges.count
    }
    
    /// 진행률 텍스트
    var progressText: String {
        return "\(completedBadgeCount)/\(totalBadgeCount)"
    }
    
    // MARK: - Init
    
    init() {
        loadBadgeData()
    }
    
    // MARK: - Methods
    
    /// 뱃지 데이터 로드
    private func loadBadgeData() {
        badges = [
            // 완료된 뱃지들 (progress = 10)
            BadgeData(
                id: "meal",
                name: "한끼했당",
                icon: Image(systemName: "star.fill"),
                progress: 10
            ),
            BadgeData(
                id: "share",
                name: "공유왕",
                icon: Image(systemName: "link"),
                progress: 10
            ),
            BadgeData(
                id: "three_meals",
                name: "삼시세끼",
                icon: Image(systemName: "sun.max.fill"),
                progress: 10
            ),
            
            // 진행 중인 뱃지들
            BadgeData(
                id: "solo_eater",
                name: "혼밥러",
                icon: Image(systemName: "person.fill"),
                progress: 7
            ),
            BadgeData(
                id: "restaurant_king",
                name: "맛집왕",
                icon: Image(systemName: "map.fill"),
                progress: 8
            ),
            
            // 잠긴 뱃지들 (progress = 0)
            BadgeData(
                id: "record_master",
                name: "기록마스터",
                icon: Image(systemName: "book.fill"),
                progress: 0
            ),
            BadgeData(
                id: "consistent_king",
                name: "꾸준왕",
                icon: Image(systemName: "calendar"),
                progress: 0
            ),
            BadgeData(
                id: "recipe_king",
                name: "레시피왕",
                icon: Image(systemName: "fork.knife"),
                progress: 0
            ),
            BadgeData(
                id: "empathy_king",
                name: "공감왕",
                icon: Image(systemName: "heart.fill"),
                progress: 0
            ),
            BadgeData(
                id: "photo_master",
                name: "사진장인",
                icon: Image(systemName: "camera.fill"),
                progress: 0
            )
        ]
    }
} 