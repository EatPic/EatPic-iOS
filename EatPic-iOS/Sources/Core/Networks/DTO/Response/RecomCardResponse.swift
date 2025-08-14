//
//  RecomCardResponse.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/14/25.
//

import Foundation

struct RecomCardResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [CardItem]
}

struct CardItem: Codable {
    let cardId: Int
    let cardImageUrl: String
}
