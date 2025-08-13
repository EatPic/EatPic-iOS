//
//  CommunityMainViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import Foundation
import SwiftUI

class CommunityMainViewModel: ObservableObject {
    
    // MARK: - View State
    @Published var selectedUser: CommunityUser?
    @Published var filteredCards: [PicCard] = sampleCards
    @Published var showDeleteModal = false
    @Published var isShowingReportBottomSheet = false
    @Published var isShowingCommentBottomSheet = false
    
    private var cardToDelete: PicCard?
    
    let toastVM = ToastViewModel()
    
    // MARK: - Computed Properties
    // 사용자 선택 처리
    func selectUser(_ user: CommunityUser) {
        selectedUser = user
        // 선택된 사용자에 따라 카드 필터링 로직 구현
        filterCards(for: user)
    }
    
    // 카드 필터링
    private func filterCards(for user: CommunityUser) {
        if user.id == "전체" { // 전체 사용자 선택 시
            filteredCards = sampleCards
        } else {
            filteredCards = sampleCards.filter { $0.user.id == user.id }
        }
    }
    
    // PicCard의 작성자가 현재 사용자인지 확인하는 메서드
    func isMyCard(_ card: PicCard) -> Bool {
        // TODO: - 실제 현재 사용자 ID와 비교하는 로직으로 변경
        // 예시: return card.user.id == currentUser.id
        return card.user.id == "나" // 임시 로직
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
    
    // 모달에서 '삭제' 버튼을 눌렀을 때 실제 삭제를 처리하는 함수
    func confirmDeletion() {
        guard let card = cardToDelete else { return }
        
        // TODO: - 실제 삭제 API 호출 로직 구현
        if let index = filteredCards.firstIndex(where: { $0.id == card.id }) {
            filteredCards.remove(at: index)
        }
        
        showDeleteModal = false
        cardToDelete = nil
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
