//
//  d.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/21/25.
//

import Foundation

struct MyCardFeedResponse: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: MyCardFeedResult
}

struct MyCardFeedResult: Codable {
    var userId: Int
    var hasNext: Bool
    var nextCursor: Int
    var cardsList: [MyCardFeedCardList]
}

struct MyCardFeedCardList: Codable {
    var cardId: Int
    var cardImageUrl: String
}
