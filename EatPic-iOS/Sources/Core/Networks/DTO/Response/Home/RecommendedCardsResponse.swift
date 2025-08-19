//
//  RecommendedCardsResponse.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/18/25.
//

import Foundation

struct RecommendedCardsResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [CardsResult]
}

struct CardsResult: Codable {
    let cardId: Int
    let cardImageUrl: String?
}
