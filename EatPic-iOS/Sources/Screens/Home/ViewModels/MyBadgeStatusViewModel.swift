import Foundation
import SwiftUI

@Observable
class MyBadgeStatusViewModel {
    
    /// 뱃지 아이템 목록
    var badgeItems: [BadgeItem] = []
    
    /// 전체 뱃지 개수
    var totalBadges: Int = 10
    
    /// 획득한 뱃지 개수
    var acquiredBadges: Int = 0
    
    /// 뱃지 아이템 구조체 (홈화면용 - 간단한 정보만)
    struct BadgeItem: Identifiable, Codable {
        let id = UUID()
        let userBadgeId: Int
        let badgeName: String
        let badgeImageUrl: String
        let progressRate: Int
        let achieved: Bool
        
        /// 기존 BadgeState와의 호환성을 위한 computed property
        var state: BadgeState {
            if achieved {
                return .completed
            } else if progressRate > 0 {
                return .progress(progress: Double(progressRate) / 100.0,
                                 icon: Image(systemName: "star.fill"))
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
} 
