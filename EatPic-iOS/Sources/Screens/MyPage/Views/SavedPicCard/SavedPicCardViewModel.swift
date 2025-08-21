//
//  SavedPicCardViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/15/25.
//

import Foundation
import Moya

@Observable
final class SavedPicCardViewModel {
    // Pagination
    var hasNext: Bool
    var nextCursor: Int?
    var feedCards: [FeedCard]
    
    /// 선택된 탭 (0: 나의 Pic 카드, 1: 잇친들의 Pic 카드)
    var selectedTab: Int
    
    /// 로딩 상태
    private(set) var isLoading: Bool

    var cardProvider: MoyaProvider<CardTargetType>

    init(container: DIContainer) {
        // 1) 저장 프로퍼티 전부 초기값 세팅
        self.hasNext = true            // 첫 로드는 true로 시작
        self.nextCursor = nil          // 첫 호출은 cursor 미포함
        self.feedCards = []
        self.selectedTab = 0           // 기본값: 나의 Pic 카드
        self.isLoading = false
        self.cardProvider = container.apiProviderStore.card()
    }

    struct FeedCard: Identifiable {
        let id: Int
        let imageUrl: String
    }

    // MARK: - API 호출 (첫 요청은 cursor 미포함)
    
    @MainActor
    func fetchSavedCards(refresh: Bool = false) async {
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
                .myPageMyCards(cursor: nextCursor, size: 15)
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

        } catch {
            print("저장한 카드 API 호출/디코딩 실패:", error)
        }
    }
    
    // MARK: - 탭 변경 시 데이터 새로고침
    @MainActor
    func onTabChanged() async {
        await fetchSavedCards(refresh: true)
    }

    // MARK: - Pagination Helper
    func loadNextPageIfNeeded(currentCard: FeedCard) async {
        guard !isLoading else { return }
        // 서버 신호 기준: nextCursor가 nil이면 더 없음
        guard nextCursor != nil else { return }

        if let idx = feedCards.firstIndex(where: { $0.id == currentCard.id }),
           idx >= feedCards.count - 6 {
            await fetchSavedCards()
        }
    }
}
