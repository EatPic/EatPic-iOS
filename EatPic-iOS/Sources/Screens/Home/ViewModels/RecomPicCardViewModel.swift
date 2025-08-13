//
//  RecomPicCardViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

@Observable
class RecomPicCardViewModel {
    /// 추천 픽카드 목록 (API 응답의 result 배열)
    var cards: [CardItem] = []
    
    struct CardItem: Identifiable, Codable {
        let id = UUID()
        let cardId: Int
        let cardImageUrl: String
        
        var imageName: String {
            return cardImageUrl
        }
    }
    
    init() {
        recomSampleData()
    }
    
    /// 샘플데이터
    private func recomSampleData() {
        cards = [
            CardItem(cardId: 1, cardImageUrl: "Home/img1"),
            CardItem(cardId: 2, cardImageUrl: "Home/img2"),
            CardItem(cardId: 3, cardImageUrl: "Home/img3"),
            CardItem(cardId: 4, cardImageUrl: "Home/img1"),
            CardItem(cardId: 5, cardImageUrl: "Home/img2"),
            CardItem(cardId: 6, cardImageUrl: "Home/img3"),
            CardItem(cardId: 1, cardImageUrl: "Home/img1"),
            CardItem(cardId: 2, cardImageUrl: "Home/img2"),
            CardItem(cardId: 3, cardImageUrl: "Home/img3"),
            CardItem(cardId: 1, cardImageUrl: "Home/img1")
        ]
    }
}
