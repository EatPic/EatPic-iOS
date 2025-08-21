//
//  CommunityMainViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import Foundation
import SwiftUI
import Moya

// MARK: - DTO

struct FeedResult: Codable {
    let selectedId: Int?
    let hasNext: Bool
    let nextCursor: Int?
    let cardFeedList: [Feed]
}

struct Feed: Codable {
    let cardId: Int
    let imageUrl: String?
    let datetime: String
    let meal: MealSlot
    let memo: String
    let recipe: String?
    let recipeUrl: String?
    let latitude: Double?
    let longitude: Double?
    let locationText: String?
    let hashtags: [String]
    let user: FeedUser
    let reactionCount: Int
    let userReaction: String?
    let commentCount: Int
    let bookmarked: Bool
}

struct UserListResult: Codable {
    let page: Int
    let size: Int
    let total: Int
    let userIconList: [UserIconDTO]
}

struct UserIconDTO: Codable, Identifiable {
    let userId: Int
    let profileImageUrl: String?
    let nameId: String
    let nickname: String?
    let introduce: String?
    let isFollowing: Bool?
    var id: Int { userId }
}

extension UserIconDTO {
    func toCommunityUser() -> CommunityUser {
        CommunityUser(
            id: userId,
            nameId: nameId,
            nickname: nickname ?? nameId,
            imageName: profileImageUrl
        )
    }
}

struct MyUserIconResult: Codable, Identifiable {
    let userId: Int
    let profileImageUrl: String?
    let nameId: String
    let nickname: String?
    let introduce: String?
    let isFollowing: Bool?
    var id: Int { userId }
}

extension MyUserIconResult {
    func toCommunityUser() -> CommunityUser {
        return CommunityUser(
            id: userId,
            nameId: nameId,
            nickname: nickname ?? nameId,
            imageName: profileImageUrl,
            introduce: introduce,
            type: .other,
            isCurrentUser: false,
            isFollowed: isFollowing ?? true
        )
    }
}

// MARK: - Mapping

extension Feed {
    func toPicCard() -> PicCard {
        let communityUser = user.toCommunityUser()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        var formattedTime = ""
        var formattedDate = ""
        if let dateObj = formatter.date(from: datetime) {
            formatter.dateFormat = "a hh:mm"
            formattedTime = formatter.string(from: dateObj)
            formatter.dateFormat = "yyyy-MM-dd"
            formattedDate = formatter.string(from: dateObj)
        }
        
        return PicCard(
            cardId: cardId,
            user: communityUser,
            time: formattedTime,
            memo: memo,
            imageUrl: imageUrl ?? "",
            date: formattedDate,
            meal: meal,
            recipe: recipe,
            recipeUrl: recipeUrl.flatMap { URL(string: $0) },
            latitude: latitude,
            longitude: longitude,
            locationText: locationText,
            hashtags: hashtags,
            reactionCount: reactionCount,
            userReaction: userReaction,
            commentCount: commentCount,
            bookmarked: bookmarked
        )
    }
}

struct FeedUser: Codable {
    let userId: Int
    let nameId: String
    let nickname: String
    let profileImageUrl: String?
}

extension FeedUser {
    func toCommunityUser() -> CommunityUser {
        CommunityUser(
            id: userId,
            nameId: nameId,
            nickname: nickname,
            imageName: profileImageUrl,
            introduce: nil,
            type: .other,
            isCurrentUser: false,
            isFollowed: true
        )
    }
}

// MARK: - ViewModel

@MainActor
final class CommunityMainViewModel: ObservableObject {
    
    // View State
    @Published var selectedUser: CommunityUser?
    @Published var filteredCards: [PicCard] = []
    @Published var users: [CommunityUser] = []
    var currentUser: CommunityUser? { users.first { $0.userType == .me } }
    @Published var hasNextPage: Bool = true
    @Published var showDeleteModal = false
    @Published var isShowingReportBottomSheet = false
    @Published var isShowingCommentBottomSheet = false
    @Published var cardToDelete: PicCard?
    @Published var nextCursor: Int? = nil
    @Published var isFetching: Bool = false
    
    let toastVM = ToastViewModel()
    let commentVM: CommentViewModel
    let cardProvider: MoyaProvider<CardTargetType>
    let bookmarkProvider: MoyaProvider<BookmarkTargetType>
    let userProvider: MoyaProvider<UserTargetType>
    let commentProvider: MoyaProvider<CommentTargetType>
    let reactionProvider: MoyaProvider<ReactionTargetType>
    
    init(container: DIContainer) {
        self.cardProvider = container.apiProviderStore.card()
        self.bookmarkProvider = container.apiProviderStore.bookmark()
        self.userProvider = container.apiProviderStore.user()
        self.commentVM = CommentViewModel(container: container)
        self.reactionProvider = container.apiProviderStore.reaction()
        self.commentProvider = container.apiProviderStore.comment()
    }
    
    // MARK: - Feeds
    
    func refreshFeeds(reset: Bool) async {
        guard !isFetching else { return }
        if reset {
            nextCursor = nil
            hasNextPage = true
            filteredCards = []
        }
        await fetchFeeds()
    }
    
    func fetchFeeds() async {
        guard hasNextPage && !isFetching else { return }

        // 사용자 목록이 아직 로드되지 않았다면 먼저 로드 (특히 .me 선택 시 내 ID 필요)
        if users.isEmpty {
            await fetchUserList()
        }

        let userIdForRequest = selectedUserIdForRequest()
        await fetchFeedsInternal(userId: userIdForRequest)
    }

    private func fetchFeedsInternal(userId: Int?, pageSize: Int = 20) async {
        isFetching = true

        do {
            let response = try await cardProvider.requestAsync(
                .fetchFeeds(
                    userId: userId,
                    cursor: nextCursor,
                    size: pageSize
                )
            )
            let dto = try JSONDecoder().decode(
                APIResponse<FeedResult>.self, from: response.data)
            let newCards = dto.result.cardFeedList.map { $0.toPicCard() }
            
            if self.nextCursor == nil {
                self.filteredCards = newCards
            } else {
                self.filteredCards.append(contentsOf: newCards)
            }
            self.nextCursor = dto.result.nextCursor
            self.hasNextPage = dto.result.hasNext
        } catch {
            print("요청/디코딩 실패:", error.localizedDescription)
            toastVM.showToast(title: "피드 로드에 실패했어요.")
        }
        isFetching = false
    }
    
    private func selectedUserIdForRequest() -> Int? {
        guard let selected = selectedUser else { return nil }
        switch selected.userType {
        case .all: return nil
        case .me: return currentUser?.id
        case .other: return selected.id
        }
    }
    
    // MARK: - Users
    
    func fetchUserList() async {
        let allUser = CommunityUser(
            id: -1,
            nameId: "전체",
            nickname: "전체",
            imageName: "Community/grid",
            introduce: nil,
            type: .all,
            isCurrentUser: false,
            isFollowed: false
        )
        
        var finalUsers: [CommunityUser] = [allUser]
        
        do {
            let meResponse = try await userProvider.requestAsync(.getMyUserIcon)
            let meDto = try JSONDecoder().decode(
                APIResponse<MyUserIconResult>.self, from: meResponse.data)
            finalUsers.append(meDto.result.toCommunityUser())
        } catch {
            print("내 정보 로드 실패:", error.localizedDescription)
        }
        
        do {
            let listResponse = try await userProvider.requestAsync(.getFollowingUserIcon)
            let listDto = try JSONDecoder().decode(
                APIResponse<UserListResult>.self, from: listResponse.data)
            let followingUsers = listDto.result.userIconList
                .filter { $0.isFollowing ?? true }
                .map { $0.toCommunityUser() }
            finalUsers.append(contentsOf: followingUsers)
        } catch {
            print("팔로우 유저 리스트 로드 실패:", error.localizedDescription)
        }
        
        self.users = finalUsers
        if self.selectedUser == nil {
            self.selectedUser = allUser
        }
    }
    
    func selectUser(_ user: CommunityUser) async {
        selectedUser = user
        await refreshFeeds(reset: true)
    }
    
    // MARK: - Card actions
    
    func isMyCard(_ card: PicCard) -> Bool {
        card.user.id == currentUser?.id
    }
    
    func showDeleteConfirmation(for card: PicCard) {
        cardToDelete = card
        showDeleteModal = true
    }
    
    func confirmDeletion() async {
        guard let card = cardToDelete else { return }
        do {
            _ = try await cardProvider.requestAsync(
                .deleteCard(cardId: card.cardId))
            if let idx = filteredCards.firstIndex(where: {
                $0.cardId == card.cardId
            }) {
                filteredCards.remove(at: idx)
            }
            toastVM.showToast(title: "삭제되었습니다.")
        } catch {
            toastVM.showToast(title: "삭제에 실패했어요. 잠시 후 다시 시도해 주세요.")
        }
        showDeleteModal = false
        cardToDelete = nil
    }
    
    func handleCardAction(cardId: Int, action: MainPicCardItemActionType) async {
        guard let index = filteredCards.firstIndex(where: { $0.cardId == cardId }) else { return }
        var card = filteredCards[index]
        
        switch action {
        case .bookmark(let isOn):
            do {
                if isOn {
                    _ = try await bookmarkProvider.requestAsync(
                        .postBookmark(cardId: cardId))
                } else {
                    _ = try await bookmarkProvider.requestAsync(
                        .deleteBookmark(cardId: cardId))
                }
                card.bookmarked = isOn
                filteredCards[index] = card
            } catch {
                toastVM.showToast(title: "북마크 처리 실패")
            }
            
        case .comment:
            isShowingCommentBottomSheet = true
            // commentVM에서 카드/스레드 설정이 필요하면 여기서 설정
            
        case .reaction(let selected, _):
            do {
                guard let newValue = selected?.rawValue else {
                    return
                }
                _ = try await reactionProvider.requestAsync(
                    .postReaction(cardId: cardId, reactionType: newValue)
                )
                // 낙관적 업데이트: 내 리액션 변경에 따른 총합 보정
                if card.userReaction == nil,
                   newValue != nil {
                    card.reactionCount += 1
                }
                if card.userReaction != nil,
                   newValue == nil {
                    card.reactionCount = max(0, card.reactionCount - 1)
                }
                card.userReaction = newValue
                filteredCards[index] = card
            } catch {
                toastVM.showToast(title: "리액션 처리 실패")
            }
        }
    }
    
    // MARK: - Etc (placeholders)
    
    func saveCardToPhotos(_ card: PicCard) {
        // PHPhotoLibrary 저장 로직이 있으면 연결
    }
    
    func editCard(_ card: PicCard) {
        // Router로 수정 화면 이동 연결
    }
    
    func handleReport(_ reason: String) {
        // 신고 API 연결 지점
        isShowingReportBottomSheet = false
        toastVM.showToast(title: "신고가 접수되었습니다.")
    }
    
    func deleteCard(card: PicCard) async {
        do {
            let response = try await cardProvider.requestAsync(.deleteCard(cardId: card.cardId))
            let dto = try JSONDecoder().decode(
                APIResponse<CardDeleteResult>.self, from: response.data)
            
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
}
