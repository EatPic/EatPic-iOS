//
//  RecomPicCardViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import Moya

@Observable
class RecomPicCardViewModel {
    private let cardProvicer: MoyaProvider<CardTargetType>
    var cards: [CardsResult] = []
    
    init(container: DIContainer) {
        self.cardProvicer = container.apiProviderStore.card()
    }
    
    @MainActor
        func fetchRecommended() async {
            do {
                let response = try await cardProvicer.requestAsync(.recommendedCard)
                let dto = try JSONDecoder().decode(
                    RecommendedCardsResponse.self,
                    from: response.data)
                self.cards = dto.result
                print(dto)
            } catch {
                print("요청 또는 디코딩 실패:", error.localizedDescription)
                self.cards = []
            }
        }
}
