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
} 
