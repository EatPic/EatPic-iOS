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
    private let cardProvider: MoyaProvider<CardTargetType>
    var cards: [CardsResult] = []
    
    init(container: DIContainer) {
        self.cardProvider = container.apiProviderStore.card()
    }
    
    @MainActor
    func fetchRecommended() async {
        do {
            let response = try await cardProvider.requestAsync(.recommendedCard)
            let dto = try JSONDecoder().decode(
                RecommendedCardsResponse.self,
                from: response.data)
            // http/https URL만 필터링하여 유효한 이미지만 받아옴
            self.cards = dto.result.filter { isValidHTTPURL($0.cardImageUrl) }
            print(dto)
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
            self.cards = []
        }
    }
    
    // MARK: - Helpers
        private func isValidHTTPURL(_ scheme: String?) -> Bool {
            guard let scheme, !scheme.isEmpty, let url = URL(string: scheme),
                  let scheme = url.scheme?.lowercased(),
                  scheme == "http" || scheme == "https" else { return false }
            return true
        }
}
