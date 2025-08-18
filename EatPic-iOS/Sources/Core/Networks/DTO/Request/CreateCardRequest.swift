//
//  CreateCardRequest.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation

/// PicCard 생성 요청 본문입니다.
/// - Important: 서버 스키마와 일치해야 하며, 멀티파트의 `request.json` 파트로 전송됩니다.
struct CreateCardRequest: Codable {
    let latitude: Double
    let longitude: Double
    let recipe: String
    let recipeUrl: String
    let memo: String
    let isShared: Bool
    let locationText: String
    let meal: MealSlot
    let hashtags: [String]
}
