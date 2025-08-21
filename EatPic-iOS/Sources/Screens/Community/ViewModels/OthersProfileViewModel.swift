import Moya
import SwiftUI

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

    // 로딩 상태
    private(set) var isLoading: Bool

    // ✅ 프로필 카운트(뷰에서 표시)
    var picCardCount: Int = 0
    var followerCount: Int = 0
    var followingCount: Int = 0

    // Providers
    var cardProvider: MoyaProvider<CardTargetType>

    init(user: CommunityUser, container: DIContainer) {
        self.user = user
        self.isFollowed = false
        self.showBlockModal = false
        self.isShowingReportBottomSheet = false
        self.hasNext = true
        self.nextCursor = nil
        self.feedCards = []
        self.isLoading = false

        self.cardProvider = container.apiProviderStore.card()

        self.isFollowed = (user.nameId == "id3")
    }

    struct FeedCard: Identifiable {
        let id: Int
        let imageUrl: String
    }

    func toggleFollow() {
        isFollowed.toggle()
    }

    func blockUser() {
        BlockedUsersManager.shared.blockUser(userId: user.nameId)
        isFollowed = false
    }

    func handleProfileReport(_ reportType: String) {
        isShowingReportBottomSheet = false
    }

    // 2) 프로필 불러오기
    @MainActor
    func fetchUserProfile() async {
        do {
            let res = try await cardProvider.requestAsync(.getUserProfile(userId: user.id))
            let decoded = try JSONDecoder().decode(
                APIResponse<ProfileDetailResult>.self,
                from: res.data)
            let user = decoded.result

            // CommunityUser 갱신
            self.user = CommunityUser(
                id: user.userId,
                nameId: user.nameId,
                nickname: user.nickname,
                imageName: user.profileImageUrl ?? UserProfileConstants.defaultImage,
                introduce: user.introduce,
                type: .other,
                isCurrentUser: false,
                isFollowed: user.isFollowing
            )

            // 팔로우 상태 & 카운트 갱신
            self.isFollowed = user.isFollowing
            self.picCardCount = user.totalCard
            self.followerCount = user.totalFollower
            self.followingCount = user.totalFollowing
        } catch {
            print("프로필 불러오기 실패:", error)
        }
    }

    // 3) 카드 페이징
    @MainActor
    func fetchUserCards(refresh: Bool = false) async {
        guard !isLoading else { return }
        if refresh {
            nextCursor = nil
            hasNext = true
            feedCards.removeAll()
        }
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
            nextCursor = decoded.result.nextCursor
        } catch {
            print("피드 API 호출/디코딩 실패:", error)
        }
    }

    func loadNextPageIfNeeded(currentCard: FeedCard) async {
        guard !isLoading else { return }
        guard nextCursor != nil else { return }
        if let idx = feedCards.firstIndex(where: { $0.id == currentCard.id }),
           idx >= feedCards.count - 6 {
            await fetchUserCards()
        }
    }
}

/// 유저 프로필 기본값
struct UserProfileConstants {
    static let defaultImage = "https://eatpic-bucket.s3.ap-northeast-2.amazonaws.com/" +
    "newcards/35f6070be118a354c97081b02c8d7dad4dfbeacc.png"
}
