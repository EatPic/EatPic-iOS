import Foundation
import SwiftUI
import Moya

@Observable
class BadgeDetailViewModel {
    
    // MARK: - Properties
    private let homeProvider: MoyaProvider<HomeTargetType>
    
    /// userBadgeId → description / current / condition 캐시
    private var descriptionById: [Int: String] = [:]
    private var currentValueById: [Int: Int] = [:]
    private var conditionValueById: [Int: Int] = [:]
    
    // MARK: - Init
    init(container: DIContainer) {
        self.homeProvider = container.apiProviderStore.home()
    }
    
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
    
    // MARK: - Func
    
    /// 뱃지 설명 응답값으로 지연 로드 (나머지는 이미 받아왔기때문에 선택적으로 응답값 생성)
    @MainActor
    func fetchDescription(userBadgeId: Int) async {
        if descriptionById[userBadgeId] != nil { return }
        do {
            let response = try await homeProvider.requestAsync(.badgeDetail(
                userBadgeID: userBadgeId))
            let dto = try JSONDecoder().decode(
                APIResponse<BadgeDetailDescDTO>.self,
                from: response.data)
    
            // 캐시 적재
            let detail = dto.result
            descriptionById[userBadgeId] = detail.badgeDescription
            currentValueById[userBadgeId] = detail.currentValue
            conditionValueById[userBadgeId] = detail.conditionValue
        } catch {
            print("배지 설명 로드 실패:", error.localizedDescription)
        }
    }
    
    /// 배지 이름에 따른 설명을 조회(없으면 뱃지 이름 반환하기)
    func description(for userBadgeId: Int, fallbackName: String) -> String {
        descriptionById[userBadgeId] ?? "\(fallbackName) 배지입니다."
    }
    
    /// 현재값/목표값 (없으면 nil)
    func values(for userBadgeId: Int) -> (current: Int, condition: Int)? {
        guard
            let cur = currentValueById[userBadgeId],
            let con = conditionValueById[userBadgeId]
        else { return nil }
        return (cur, con)
    }
    
    /// 배지 상태에 따른 모달 타입을 생성합니다
    func createBadgeModalType(for badge: MyBadgeStatusViewModel.BadgeItem) -> BadgeModalType {
        switch badge.state {
        case .progress(let progress, let iconURL):
            return .badgeUnlocked(progress: progress, iconURL: iconURL)
        case .locked:
            return .badgeLocked
        case .completed(let url):
            return .badgeCompleted(iconURL: url)
        }
    }
}
