import Foundation
import SwiftUI

// MARK: - Import BadgeModalType
// BadgeModalType은 같은 프로젝트 내에 있으므로 별도 import 불필요

@Observable
class MyBadgeStatusViewModel {
    
    /// 뱃지 아이템 목록
    var badgeItems: [BadgeItem] = []
    
    /// 전체 뱃지 개수
    var totalBadges: Int = 10
    
    /// 획득한 뱃지 개수
    var acquiredBadges: Int = 0
    
    
    struct BadgeItem: Identifiable, Codable {
        let id = UUID()
        let userBadgeId: Int
        let badgeName: String
        let badgeImageUrl: String
        let progressRate: Int
        let achieved: Bool
        
        var state: BadgeState {
            if achieved {
                return .completed
            } else if progressRate > 0 {
                return .progress(progress: Double(progressRate)
                                 / 100.0, icon: Image(systemName: "star.fill"))
            } else {
                return .locked
            }
        }
        
        /// 기존 name과의 호환성을 위한 computed property
        var name: String {
            return badgeName
        }
    }
    
    init() {
        setupSampleData()
        updateAcquiredBadgesCount()
    }
    
    /// 샘플 데이터 설정 (API 연동 전까지 사용)
    private func setupSampleData() {
        badgeItems = [
            BadgeItem(userBadgeId: 1, badgeName: "한끼했당",
                      badgeImageUrl: "", progressRate: 40,
                      achieved: false),
            BadgeItem(userBadgeId: 2, badgeName: "공유왕",
                      badgeImageUrl: "", progressRate: 60,
                      achieved: false),
            BadgeItem(userBadgeId: 3, badgeName: "삼시세끼",
                      badgeImageUrl: "", progressRate: 80,
                      achieved: false),
            BadgeItem(userBadgeId: 4, badgeName: "기록마스터",
                      badgeImageUrl: "", progressRate: 0,
                      achieved: false),
            BadgeItem(userBadgeId: 5, badgeName: "혼밥러",
                      badgeImageUrl: "", progressRate: 30,
                      achieved: false),
            BadgeItem(userBadgeId: 6, badgeName: "꾸준왕",
                      badgeImageUrl: "", progressRate: 0,
                      achieved: false),
            BadgeItem(userBadgeId: 7, badgeName: "맛집왕",
                      badgeImageUrl: "", progressRate: 70,
                      achieved: false),
            BadgeItem(userBadgeId: 8, badgeName: "레시피왕",
                      badgeImageUrl: "", progressRate: 0,
                      achieved: false),
            BadgeItem(userBadgeId: 9, badgeName: "공감왕",
                      badgeImageUrl: "", progressRate: 0,
                      achieved: false),
            BadgeItem(userBadgeId: 10, badgeName: "사진장인",
                      badgeImageUrl: "", progressRate: 0,
                      achieved: false)
        ]
    }
    
    /// 획득한 뱃지 개수 업데이트
    private func updateAcquiredBadgesCount() {
        acquiredBadges = badgeItems.filter { $0.achieved }.count
    }
    
    func getBadgeStatus() -> String {
        return "\(acquiredBadges)"
    }
    
    // MARK: - Helper Methods
    
    /// 배지 상태에 따른 모달 타입을 생성합니다
    /// - Parameter badge: 선택된 배지 아이템
    /// - Returns: BadgeModalType
    func createBadgeModalType(for badge: BadgeItem) -> BadgeModalType {
        switch badge.state {
        case .progress(let progress, let icon):
            return .badgeUnlocked(progress: progress, icon: icon)
        case .locked:
            return .badgeLocked
        case .completed:
            return .badgeCompleted
        }
    }
    
    /// 배지 이름에 따른 설명을 반환합니다
    /// - Parameter badgeName: 배지 이름
    /// - Returns: 배지 설명 텍스트
    func getBadgeDescription(for badgeName: String) -> String {
        return badgeDescriptions[badgeName] ?? "" 
    }
    
    /// 배지별 설명 딕셔너리
    private let badgeDescriptions: [String: String] = [
        "한끼했당": "설명~",
        "공유왕": "설명~",
        "삼시세끼": "설명~",
        "기록마스터": "설명~",
        "혼밥러": "설명~",
        "꾸준왕": "설명~",
        "맛집왕": "설명~",
        "레시피왕": "설명~",
        "공감왕": "설명~",
        "사진장인": "설명~"
    ]
} 
