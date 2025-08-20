//
//  CommunityMainViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import Foundation
import SwiftUI
import Moya

@MainActor
@Observable
class CommunityMainViewModel {
    
    // MARK: - View State
    var selectedUser: CommunityUser?
    var filteredCards: [PicCard] = sampleCards // 초기값을 비어있는 배열로 변경
    var users: [CommunityUser] = []
    var currentUser: CommunityUser? {
        users.first { $0.userType == .me }
    }
    var hasNextPage: Bool = true
    var showDeleteModal = false
    var isShowingReportBottomSheet = false
    var isShowingCommentBottomSheet = false
    
    private var cardToDelete: PicCard?
    private var nextCursor: Int? = nil
    private var isFetching: Bool = false
    
    let toastVM = ToastViewModel()
    let commentVM: CommentViewModel
    private let cardProvider: MoyaProvider<CardTargetType>
    private let bookmarkProvider: MoyaProvider<BookmarkTargetType>
    private let userProvider: MoyaProvider<UserTargetType>
    private let commentProvider: MoyaProvider<CommentTargetType>
    private let reactionProvider: MoyaProvider<ReactionTargetType>
    
    init(container: DIContainer) {
        // APIProviderStore에서 제작한 함수 호출
        self.cardProvider = container.apiProviderStore.card()
        self.bookmarkProvider = container.apiProviderStore.bookmark()
        self.userProvider = container.apiProviderStore.user()
        self.commentVM = CommentViewModel(container: container)
        self.reactionProvider = container.apiProviderStore.reaction()
        self.commentProvider = container.apiProviderStore.comment()
    }
    
    func fetchFeeds() async {
        guard hasNextPage && !isFetching else { return }
        guard let myId = currentUser?.id else {
            print("❌ 로그인된 유저 ID를 찾을 수 없음")
            return
        }
        
        self.isFetching = true
        let pageSize = 15
        
        do {
            let response = try await cardProvider.requestAsync(
                .fetchFeeds(userId: myId, cursor: nextCursor, size: pageSize))
            let dto = try JSONDecoder().decode(
                APIResponse<FeedResult>.self, from: response.data)
            
            // 핵심 변환 로직: Feed 배열을 PicCard 배열로 변환
            let newCards = dto.result.cardFeedList.map { feed in
                feed.toPicCard()
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
    func fetchUserList() async {
        // 기본 '전체' 사용자
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
            // 1) 나의 정보 가져오기
            let meResponse = try await userProvider.requestAsync(.getMyUserIcon)
            let meDto = try JSONDecoder().decode(APIResponse<MyUserIconResult>.self,
                                                 from: meResponse.data)
            let myUser = meDto.result.toCommunityUser()
            finalUsers.append(myUser)
            
            print("내 정보 로드 성공: \(myUser.nameId)")
            
        } catch {
            print("내 정보 로드 실패:", error.localizedDescription)
            // 내 정보 로드 실패해도 전체는 표시
        }
        
        do {
            // 2) 팔로우 중인 유저 목록 가져오기
            let listResponse = try await userProvider.requestAsync(.getFollowingUserIcon)
            let listDto = try JSONDecoder().decode(APIResponse<UserListResult>.self,
                                                   from: listResponse.data)
            
            // isFollowing == true인 유저만 필터링
            let followingUsers = listDto.result.userIconList
                .filter { $0.isFollowing ?? true }
                .map { $0.toCommunityUser() }
            
            finalUsers.append(contentsOf: followingUsers)
            print("팔로우 유저 \(followingUsers.count)명 로드 성공")
            
        } catch {
            print("팔로우 유저 리스트 로드 실패:", error.localizedDescription)
            print("상세 에러: \(error)")
            
            // 팔로우 유저가 없거나 에러가 발생해도 기본 사용자들(전체, 나)은 표시
            if let moyaError = error as? MoyaError {
                switch moyaError {
                case .statusCode(let response):
                    print("HTTP 상태 코드: \(response.statusCode)")
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("서버 응답: \(responseString)")
                    }
                case .underlying(let nsError, let response):
                    print("하위 에러: \(nsError)")
                    if let response = response,
                       let responseString = String(data: response.data, encoding: .utf8) {
                        print("응답 데이터: \(responseString)")
                    }
                default:
                    break
                }
            }
        }
        
        // UI 업데이트
        DispatchQueue.main.async {
            self.users = finalUsers
            
            // 초기 선택값은 "전체"
            if self.selectedUser == nil {
                self.selectedUser = allUser
            }
            
            print("최종 사용자 리스트: \(self.users.map { $0.nameId })")
        }
    }
    
    // MARK: - Computed Properties
    // 사용자 선택 처리
    func selectUser(_ user: CommunityUser) {
        selectedUser = user
    }
    
    // PicCard의 작성자가 현재 사용자인지 확인하는 메서드
    func isMyCard(_ card: PicCard) -> Bool {
        guard let me = currentUser else { return false }
        return card.user.id == me.id
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
    func handleCardAction(cardId: Int, action: PicCardItemActionType) async {
        switch action {
        case .bookmark(let isOn):
            await handleBookmarkAction(cardId: cardId, isOn: isOn)
        case .comment(let count):
            await handleCommentAction(cardId: cardId, count: count)
        case .reaction(let selected, let counts):
            await handleReactionAction(cardId: cardId, selected: selected,
                                       previousReaction: selected, counts: counts)
        }
    }
    
    func postBookmark(cardId: Int) async {
        do {
            let response = try await bookmarkProvider.requestAsync(.postBookmark(cardId: cardId))
            let dto = try JSONDecoder().decode(
                APIResponse<BookmarkResult>.self, from: response.data)
            
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
    
    func deleteBookmark(cardId: Int) async {
        do {
            let response = try await bookmarkProvider.requestAsync(.deleteBookmark(cardId: cardId))
            let dto = try JSONDecoder().decode(
                APIResponse<BookmarkResult>.self, from: response.data)
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
    
    // 북마크 액션 처리
    private func handleBookmarkAction(cardId: Int, isOn: Bool) async {
        if isOn {
            // 북마크 추가
            await postBookmark(cardId: cardId)
        } else {
            // 북마크 해제
            await deleteBookmark(cardId: cardId)
        }
        
        // UI 업데이트
        updateCardBookmarkStatus(cardId: cardId, isBookmarked: isOn)
        
        // 선택적으로 토스트 메시지 표시 (PicCardItemView에서 이미 처리되므로 중복 방지)
        print("북마크 상태 변경: \(isOn) for card: \(cardId)")
    }
    
    // 댓글 액션 처리
    @MainActor
    private func handleCommentAction(cardId: Int, count: Int) {
        isShowingCommentBottomSheet = true
        commentVM.selectedCardId = cardId
        
        // 디버깅을 위한 로그 추가
            print("댓글 액션 처리 - cardId: \(cardId), count: \(count)")
            print("isShowingCommentBottomSheet 상태: \(isShowingCommentBottomSheet)")
    }
    
    func postComment(cardId: Int, content: String, parentCommentId: Int = 0) async {
        let request = CommentRequest(
            parentCommentId: parentCommentId, content: content)
        
        do {
            let response = try await commentProvider.requestAsync(
                .postComment(cardId: cardId, request: request))
            let dto = try JSONDecoder().decode(
                APIResponse<CommentPostResult>.self, from: response.data)
            
            print("댓글 등록 성공:", dto)
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
    
    // 리액션 추가/수정/삭제
//    func postReaction(cardId: Int, type: ReactionType) async {
//        guard let reactionToServer = ReactionTypes(rawValue: type.rawValue) else {
//            print("Error: Could not convert reaction type \(type.rawValue) to server type")
//            return
//        }
//        
//        do {
//            _ = try await reactionProvider.requestAsync(
//                .postReaction(cardId: cardId, reactionType: reactionToServer))
//            print("리액션 등록/삭제 성공")
//        } catch {
//            print("리액션 등록/삭제 실패:", error.localizedDescription)
//        }
//    }
    
    // 리액션 액션 처리
    @MainActor
    private func handleReactionAction(
        cardId: Int,
        selected: ReactionType?,
        previousReaction: ReactionType?,
        counts: [ReactionType: Int]
    ) async {
        do {
            if let newReaction = selected,
               let serverReaction = ReactionTypes(rawValue: newReaction.rawValue) {
                // 새로운 리액션 등록
                try await reactionProvider.requestAsync(
                    .postReaction(cardId: cardId, reactionType: serverReaction.rawValue)
                )
            } else if let prev = previousReaction,
                      let serverReaction = ReactionTypes(rawValue: prev.rawValue) {
                // 같은 리액션 삭제
                try await reactionProvider.requestAsync(
                    .postReaction(cardId: cardId, reactionType: serverReaction.rawValue)
                )
            }
        } catch {
            print("리액션 API 실패:", error)
        }
        
        // 실제 구현: API 호출하여 서버에 리액션 상태 업데이트
        let totalCount = counts.values.reduce(0, +)
        updateCardReactionInfo(
            cardId: cardId,
            reactionCount: totalCount,
            userReaction: selected?.rawValue
        )
        
        print("리액션 상태 변경: \(String(describing: selected)) for card: \(cardId)")
        print("리액션 카운트: \(counts)")
    }
    
    // 특정 카드의 북마크 상태 업데이트
    func updateCardBookmarkStatus(cardId: Int, isBookmarked: Bool) {
        if let index = filteredCards.firstIndex(where: { $0.cardId == cardId }) {
            filteredCards[index].bookmarked = isBookmarked
        }
    }
    
    // 특정 카드의 리액션 정보 업데이트
    func updateCardReactionInfo(cardId: Int, reactionCount: Int, userReaction: String?) {
        if let index = filteredCards.firstIndex(where: { $0.cardId == cardId }) {
            filteredCards[index].updateReaction(newReaction: userReaction, newCount: reactionCount)
        }
    }
    
    // 특정 카드의 댓글 수 업데이트
    func updateCardCommentCount(cardId: Int, commentCount: Int) {
        if let index = filteredCards.firstIndex(where: { $0.cardId == cardId }) {
            filteredCards[index].updateCommentCount(commentCount)
        }
    }
}
