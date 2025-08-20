//
//  OthersProfileViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/8/25.
//

import Foundation
import Moya

@Observable
final class OthersProfileViewModel {
    var user: CommunityUser
    var isFollowed: Bool = true
    var showBlockModal: Bool = false
    var isShowingReportBottomSheet: Bool = false
    
    // Pagination
    var hasNext: Bool = false
    var nextCursor: Int = 0
    // API 기반 카드 리스트
    var feedCards: [FeedCard] = []
    
    var cardProvider: MoyaProvider<CardTargetType>?
    
    init(user: CommunityUser) {
            self.user = user
            self.isFollowed = checkFollowStatus(for: user)
            self.cardProvider = nil // container가 아직 없을 때는 nil
        }

        func setCardProvider(_ provider: MoyaProvider<CardTargetType>) {
            self.cardProvider = provider
        }

        private func checkFollowStatus(for user: CommunityUser) -> Bool {
            return user.nameId == "id3" ? true : false
        }
    
    private var allUsers: [CommunityUser] = sampleUsers
    private var allPicCards: [PicCard] = sampleCards
    
    var picCardCount: Int {
        allPicCards.filter { $0.user.id == user.id }.count
    }
    
    var followerCount: Int {
        // 더미 데이터에는 팔로워 정보가 없으므로 임의의 값 반환
        return 2
    }
    
    var followingCount: Int {
        // 더미 데이터에는 팔로잉 정보가 없으므로 임의의 값 반환
        return 2
    }
    
    //    var userCards: [PicCard] {
    //        allPicCards.filter { $0.user.id == user.id }
    //    }
    
    struct FeedCard: Identifiable {
        let id: Int
        let imageUrl: String
    }
    
    func toggleFollow() {
        // TODO: 실제 팔로우/언팔로우 API 호출 로직 구현
        isFollowed.toggle()
        print("\(user.nickname) 팔로우 상태 변경: \(isFollowed)")
    }
    
    func blockUser() {
        // BlockedUsersManager를 통해 차단 처리
        BlockedUsersManager.shared.blockUser(userId: user.nameId)
        isFollowed = false
        print("\(user.nickname) 차단 완료")
    }
    
    func handleProfileReport(_ reportType: String) {
        print("프로필 신고: \(user.nameId) - 유형: \(reportType)")
        // TODO: 실제 신고 API 호출 로직 구현
        isShowingReportBottomSheet = false
    }
    
//    private func checkFollowStatus(for user: CommunityUser) -> Bool {
//        // TODO: 실제 팔로우 상태를 확인하는 로직 구현 (API 호출 등)
//        // 현재는 더미 데이터로 임시 구현
//        return user.nameId == "id3" ? true : false
//    }
    
    // MARK: - API 호출
    func fetchUserCards(cursor: Int = 0) async {
        guard let provider = cardProvider else {
            print("cardProvider가 설정되지 않았습니다.")
            return
        }
        
        do {
            let response = try await provider.requestAsync(
                .profileFeed(userId: user.id, cursor: cursor, size: 15))
            let decoded = try JSONDecoder().decode(
                APIResponse<ProfileFeedResult>.self, from: response.data)
            
            let newCards = decoded.result.cardsList.map { cardItem in
                FeedCard(id: cardItem.cardId, imageUrl: cardItem.cardImageUrl)
            }
            
            // 기존 배열에 추가
            self.feedCards.append(contentsOf: newCards)
            self.hasNext = decoded.result.hasNext
            self.nextCursor = decoded.result.nextCursor ?? 0
            
        } catch {
            print("피드 API 호출/디코딩 실패:", error)
        }
    }
    
    // MARK: - Pagination Helper
    func loadNextPageIfNeeded(currentCard: FeedCard) async {
            guard hasNext, let last = feedCards.last, last.id == currentCard.id else { return }
            await fetchUserCards(cursor: nextCursor)
        }
}
