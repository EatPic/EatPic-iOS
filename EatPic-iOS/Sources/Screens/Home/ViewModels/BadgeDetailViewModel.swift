import Foundation
import SwiftUI

@Observable
class BadgeDetailViewModel {
    var badgeDetail: BadgeDetail?
    
    struct BadgeDetail: Codable {
        let userBadgeId: Int
        let badgeName: String
        let badgeDescription: String
        let badgeImageUrl: String
        let progressRate: Int
        let isAchieved: Bool
        let currentValue: Int
        let conditionValue: Int
        
        var achieved: Bool {
            return isAchieved
        }

        /// 진행률을 0.0 ~ 1.0 범위로 변환
        var progress: Double {
            return Double(progressRate) / 100.0
        }
    }

    /// 배지 상태에 따른 모달 타입을 생성합니다
    func createBadgeModalType(for badge: MyBadgeStatusViewModel.BadgeItem) -> BadgeModalType {
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
    func getBadgeDescription(for badgeName: String) -> String {
        // 현재는 기본 설명 반환, 나중에 API 연동 시 badgeDetail.badgeDescription 사용
        return "뱃지 설명입니다."
    }
}
