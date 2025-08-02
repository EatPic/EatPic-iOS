import SwiftUI

class MyBadgeStatusViewModel: ObservableObject {
    @Published var badgeItems: [BadgeItem] = []
    @Published var totalBadges: Int = 10
    @Published var acquiredBadges: Int = 0
    
    init() {
        loadBadgeData()
    }
    
    private func loadBadgeData() {
        // TODO: API에서 실제 데이터를 가져와서 설정
        badgeItems = [
            BadgeItem(state: .progress(progress: 0.4,
                                       icon: Image(systemName: "star.fill")), name: "한끼했당"),
            BadgeItem(state: .progress(progress: 0.6,
                                       icon: Image(systemName: "star.fill")), name: "공유왕"),
            BadgeItem(state: .progress(progress: 0.8,
                                       icon: Image(systemName: "star.fill")), name: "삼시세끼"),
            BadgeItem(state: .locked, name: "기록마스터"),
            BadgeItem(state: .progress(progress: 0.3,
                                       icon: Image(systemName: "star.fill")), name: "혼밥러"),
            BadgeItem(state: .locked, name: "꾸준왕"),
            BadgeItem(state: .progress(progress: 0.7,
                                       icon: Image(systemName: "star.fill")), name: "맛집왕"),
            BadgeItem(state: .locked, name: "레시피왕"),
            BadgeItem(state: .locked, name: "공감왕"),
            BadgeItem(state: .locked, name: "사진장인")
        ]
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
