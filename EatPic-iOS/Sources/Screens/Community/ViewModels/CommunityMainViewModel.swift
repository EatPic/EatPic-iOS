//
//  CommunityMainViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import Foundation
import SwiftUI
import Moya

@Observable
class CommunityMainViewModel {
    
    // MARK: - View State
    var selectedUser: CommunityUser?
    var filteredCards: [PicCard] = [] // 초기값을 비어있는 배열로 변경
    var users: [CommunityUser] = []
    var hasNextPage: Bool = true
    var showDeleteModal = false
    var isShowingReportBottomSheet = false
    var isShowingCommentBottomSheet = false
    
    private var cardToDelete: PicCard?
    private var nextCursor: Int? = nil
    private var isFetching: Bool = false
    
    let toastVM = ToastViewModel()
    private let cardProvider: MoyaProvider<CardTargetType>
    private let userProvider: MoyaProvider<UserTargetType>
    
    init(container: DIContainer) {
        // APIProviderStore에서 제작한 함수 호출
        self.cardProvider = container.apiProviderStore.card()
        self.userProvider = container.apiProviderStore.user()
    }
    
    func fetchFeeds() async {
        guard hasNextPage && !isFetching else { return }
        
        self.isFetching = true
        let pageSize = 15
        
        do {
            let response = try await cardProvider.requestAsync(
                .fetchFeeds(userId: 24, cursor: nextCursor, size: pageSize))
            let dto = try JSONDecoder().decode(
                APIResponse<FeedResult>.self, from: response.data)
            
            // 핵심 변환 로직: Feed 배열을 PicCard 배열로 변환
            let newCards = dto.result.cardFeedList.map { feed in
                PicCard(from: feed)
            }
            
            DispatchQueue.main.async {
                if self.nextCursor == nil {
                    self.filteredCards = newCards
                } else {
                    self.filteredCards.append(contentsOf: newCards)
                }
                
                self.nextCursor = dto.result.nextCursor
                self.hasNextPage = dto.result.hasNext
                self.isFetching = false
            }
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
    
    // userList 불러오기
        func fetchUsers() async {
            do {
                let response = try await userProvider.requestAsync(.getFollowingUserIcon)
                let dto = try JSONDecoder().decode(APIResponse<UserIconResult>.self,
                                                   from: response.data)

                let newUsers = dto.result.userIconList.map { userIcon in
                    CommunityUser(
                        userId: userIcon.userId,
                        nameId: userIcon.nameId,
                        nickname: userIcon.nickname,
                        profileImage: userIcon.profileImageUrl,
                        introduce: userIcon.introduce
                    )
                }

                DispatchQueue.main.async {
                    self.users = newUsers
                }
            } catch {
                print("사용자 리스트 요청/디코딩 실패:", error.localizedDescription)
            }
        }
    
    // MARK: - Computed Properties
    // 사용자 선택 처리
    func selectUser(_ user: CommunityUser) {
        selectedUser = user
        // 선택된 사용자에 따라 카드 필터링 로직 구현
        //            filterCards(for: user)
    }
    
    // PicCard의 작성자가 현재 사용자인지 확인하는 메서드
    func isMyCard(_ card: PicCard) -> Bool {
        // TODO: - 실제 현재 사용자 ID와 비교하는 로직으로 변경
        // 예시: return card.user.id == currentUser.id
        return card.user.id == 24 // 임시 로직
    }
    
    // MARK: - Actions
    // PicCard의 메뉴 액션을 처리하는 함수 (예시)
    func saveCardToPhotos(_ card: PicCard) {
        toastVM.showToast(title: "사진 앱에 저장되었습니다.")
        print("사진 앱에 저장: \(card.id)")
        // TODO: - UIImageWriteToSavedPhotosAlbum 등을 이용한 실제 저장 로직 구현
    }
    
    func editCard(_ card: PicCard) {
        print("수정하기: \(card.id)")
        // TODO: - 카드 수정 화면으로 이동하는 로직 구현
    }
    
    func showDeleteConfirmation(for card: PicCard) {
        cardToDelete = card
        showDeleteModal = true
        print("삭제 확인 모달 띄우기: \(card.id)")
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
    
    // 모달에서 '삭제' 버튼을 눌렀을 때 실제 삭제를 처리하는 함수
    func confirmDeletion() async {
        guard let card = cardToDelete else { return }
        
        await deleteCard(card: card)
        
        // UI 업데이트: filteredCards에서 삭제
        if let index = filteredCards.firstIndex(where: { $0.id == card.id }) {
            filteredCards.remove(at: index)
        }
        
        // 모달 닫기 & 상태 초기화
        showDeleteModal = false
        cardToDelete = nil
        
        // 토스트 표시
        toastVM.showToast(title: "삭제되었습니다.")
        print("카드 삭제 완료: \(card.id)")
    }
    
    // 신고 처리
    func handleReport(_ reason: String) {
        isShowingReportBottomSheet = false
        toastVM.showToast(title: "신고가 접수되었습니다.")
        print("신고 사유: \(reason)")
    }
    
    // 카드 아이템 액션 처리 (카드 ID와 함께)
    func handleCardAction(cardId: UUID, action: PicCardItemActionType) {
        switch action {
        case .bookmark(let isOn):
            handleBookmarkAction(cardId: cardId, isOn: isOn)
        case .comment(let count):
            handleCommentAction(cardId: cardId, count: count)
        case .reaction(let selected, let counts):
            handleReactionAction(cardId: cardId, selected: selected, counts: counts)
        }
    }
    
    // 북마크 액션 처리
    private func handleBookmarkAction(cardId: UUID, isOn: Bool) {
        // 실제 구현: API 호출하여 서버에 북마크 상태 업데이트
        updateCardBookmarkStatus(cardId: cardId, isBookmarked: isOn)
        
        // 선택적으로 토스트 메시지 표시 (PicCardItemView에서 이미 처리되므로 중복 방지)
        print("북마크 상태 변경: \(isOn) for card: \(cardId)")
    }
    
    // 댓글 액션 처리
    private func handleCommentAction(cardId: UUID, count: Int) {
        isShowingCommentBottomSheet = true
    }
    
    // 리액션 액션 처리
    private func handleReactionAction(
        cardId: UUID, selected: ReactionType?,
        counts: [ReactionType: Int]) {
            // 실제 구현: API 호출하여 서버에 리액션 상태 업데이트
            let totalCount = counts.values.reduce(0, +)
            updateCardReactionInfo(
                cardId: cardId, reactionCount: totalCount,
                userReaction: selected?.rawValue)
            
            print("리액션 상태 변경: \(String(describing: selected)) for card: \(cardId)")
            print("리액션 카운트: \(counts)")
        }
    
    // 특정 카드의 북마크 상태 업데이트
    func updateCardBookmarkStatus(cardId: UUID, isBookmarked: Bool) {
        if let index = filteredCards.firstIndex(where: { $0.id == cardId }) {
            filteredCards[index].bookmarked = isBookmarked
        }
    }
    
    // 특정 카드의 리액션 정보 업데이트
    func updateCardReactionInfo(cardId: UUID, reactionCount: Int, userReaction: String?) {
        if let index = filteredCards.firstIndex(where: { $0.id == cardId }) {
            filteredCards[index].updateReaction(newReaction: userReaction, newCount: reactionCount)
        }
    }
    
    // 특정 카드의 댓글 수 업데이트
    func updateCardCommentCount(cardId: UUID, commentCount: Int) {
        if let index = filteredCards.firstIndex(where: { $0.id == cardId }) {
            filteredCards[index].updateCommentCount(commentCount)
        }
    }
}
