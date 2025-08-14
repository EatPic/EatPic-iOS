//
//  RecomPicCardViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import Moya

struct RecomCardModel {
    let cardId: Int
    let cardImageUrl: URL
}

@Observable
class RecomPicCardViewModel {
//    var cards: [RecomCardModel] = []
    
    private let recomCardprovider: MoyaProvider<CardTargetType>

    init(container: DIContainer) {
        self.recomCardprovider = container.apiProviderStore.recomCard()
    }
    
    @MainActor
    func fetchRecommendedCards() async {
        do {
            let response = try await recomCardprovider.request(.fetchRecommendedCards)
        
            let dto = try JSONDecoder().decode(RecomCardResponse.self, from: response.data)

            print(dto)
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
}
