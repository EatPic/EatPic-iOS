import Foundation
import Moya

@Observable
final class OthersProfileViewModel {
    var user: CommunityUser
    var isFollowed: Bool
    var showBlockModal: Bool
    var isShowingReportBottomSheet: Bool

    // Pagination
    var hasNext: Bool
    var nextCursor: Int?
    var feedCards: [FeedCard]

    /// 로딩 상태
    private(set) var isLoading: Bool

    var cardProvider: MoyaProvider<CardTargetType>

    init(user: CommunityUser, container: DIContainer) {
        // 1) 저장 프로퍼티 전부 초기값 세팅
        self.user = user
        self.isFollowed = false
        self.showBlockModal = false
        self.isShowingReportBottomSheet = false
        self.hasNext = true            // 첫 로드는 true로 시작
        self.nextCursor = nil          // 첫 호출은 cursor 미포함
        self.feedCards = []
        self.isLoading = false
        self.cardProvider = container.apiProviderStore.card()

        // 2) 이제 안전하게 파생값 설정 가능
        self.isFollowed = (user.nameId == "id3")
    }

    private var allUsers: [CommunityUser] = sampleUsers
    private var allPicCards: [PicCard] = sampleCards

    var picCardCount: Int {
        allPicCards.filter { $0.user.id == user.id }.count
    }
    var followerCount: Int { 2 }
    var followingCount: Int { 2 }

    struct FeedCard: Identifiable {
        let id: Int
        let imageUrl: String
    }

    func toggleFollow() {
        isFollowed.toggle()
        print("\(user.nickname) 팔로우 상태 변경: \(isFollowed)")
    }

    func blockUser() {
        BlockedUsersManager.shared.blockUser(userId: user.nameId)
        isFollowed = false
        print("\(user.nickname) 차단 완료")
    }

    func handleProfileReport(_ reportType: String) {
        print("프로필 신고: \(user.nameId) - 유형: \(reportType)")
        isShowingReportBottomSheet = false
    }

    // MARK: - API 호출 (첫 요청은 cursor 미포함)
    
    @MainActor
    func fetchUserCards(refresh: Bool = false) async {
        guard !isLoading else { return }

        if refresh {
            nextCursor = nil
            hasNext = true
            feedCards.removeAll()
        }

        // nextCursor == nil && refresh 아님이면 더 없음
        if !refresh, nextCursor == nil, !feedCards.isEmpty { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await cardProvider.requestAsync(
                .profileFeed(userId: user.id, cursor: nextCursor, size: 15)
            )
            let decoded = try JSONDecoder().decode(
                APIResponse<ProfileFeedResult>.self,
                from: response.data)

            let newCards = decoded.result.cardsList.map {
                FeedCard(id: $0.cardId, imageUrl: $0.cardImageUrl)
            }

            feedCards.append(contentsOf: newCards)
            hasNext = decoded.result.hasNext
            nextCursor = decoded.result.nextCursor // 0으로 덮어쓰지 않기

            print(newCards)
        } catch {
            print("피드 API 호출/디코딩 실패:", error)
        }
    }

    // MARK: - Pagination Helper
    func loadNextPageIfNeeded(currentCard: FeedCard) async {
        guard !isLoading else { return }
        // 서버 신호 기준: nextCursor가 nil이면 더 없음
        guard nextCursor != nil else { return }

        if let idx = feedCards.firstIndex(where: { $0.id == currentCard.id }),
           idx >= feedCards.count - 6 {
            await fetchUserCards()
        }
    }
}
