//
//  ProfileFeedResult.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/21/25.
//

import Foundation
struct ProfileFeedResult: Codable {
    let userId: Int
    let hasNext: Bool
    let nextCursor: Int?
    let cardsList: [ProfileFeedList]
}

struct ProfileFeedList: Codable {
    let cardId: Int
    let cardImageUrl: String
}
