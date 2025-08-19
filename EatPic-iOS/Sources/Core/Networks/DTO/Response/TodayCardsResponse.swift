//
//  TodayCardsResponse.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/19/25.
//

import Foundation

struct TodayCardsResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [TodayCardsResult]
}

struct TodayCardsResult: Codable {
    let cardId: Int
    let cardImageUrl: String
    let meal: MealSlot
}
