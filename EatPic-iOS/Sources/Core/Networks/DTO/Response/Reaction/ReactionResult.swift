//
//  ReactionResult.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/19/25.
//

import Foundation

struct ReactionResult: Codable {
    let cardId: Int
    let userId: Int
    let reactionType: ReactionTypes
    let status: String
}

enum ReactionTypes: String, Codable {
    case thumbUp = "THUMB_UP"
    case heart = "HEART"
    case yummy = "YUMMY"
    case power = "POWER"
    case laugh = "LAUGH"
}
