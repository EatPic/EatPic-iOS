import Foundation
import SwiftUI
import Moya

final class MyBadgeStatusViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// API 연결을 위한 프로바이더
    private let homeProvider: MoyaProvider<HomeTargetType>
    
    /// 뱃지 아이템 목록
    @Published var badgeItems: [BadgeItem] = [] {
        didSet {
            updateAcquiredBadgesCount()
            totalBadges = badgeItems.count
        }
    }
    
    /// 전체 뱃지 개수
    @Published var totalBadges: Int = 0
    
    /// 획득한 뱃지 개수
    @Published var acquiredBadges: Int = 0
    
    /// 뱃지 아이템 구조체 (홈화면용 - 간단한 정보만)
    struct BadgeItem: Identifiable, Codable {
        var id: Int { userBadgeId }
        let userBadgeId: Int
        let badgeName: String
        let badgeImageUrl: String
        let progressRate: Int
        let achieved: Bool
        
        /// 기존 BadgeState와의 호환성을 위한 computed property
        var state: BadgeState {
            if achieved {
                return .completed(iconURL: badgeImageUrl)
            } else if progressRate > 0 {
                return .progress(
                    progress: Double(progressRate) / 100.0,
                    iconURL: badgeImageUrl)
            } else {
                return .locked
            }
        }
        
        /// 기존 name과의 호환성을 위한 computed property
        var name: String {
            return badgeName
        }
    }
    
    // MARK: - Init

    init(container: DIContainer) {
        self.homeProvider = container.apiProviderStore.home()
    }
    
    // MARK: - Methods
    
    /// 획득한 뱃지 개수 업데이트
    private func updateAcquiredBadgesCount() {
        acquiredBadges = badgeItems.filter { $0.achieved }.count
    }
    
    func getBadgeStatus() -> String {
        return "\(acquiredBadges)"
    }
    
    // MARK: - API Method
    
    @MainActor
    func fetchBadgeList() async {
        do {
            let response = try await
            homeProvider.requestAsync(.badgeList)
            let dto = try JSONDecoder().decode(
                BadgeListResponse.self,
                from: response.data)
            
            /// 서버에서 받은 응답과 기존에 쓰던 모델 매핑하기
            badgeItems = dto.result.map { BadgeItem(
                userBadgeId: $0.userBadgeId,
                badgeName: $0.badgeName,
                badgeImageUrl: $0.badgeImageUrl,
                progressRate: $0.progressRate,
                achieved: $0.achieved || $0.progressRate >= 100
            ) }
            
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
}
