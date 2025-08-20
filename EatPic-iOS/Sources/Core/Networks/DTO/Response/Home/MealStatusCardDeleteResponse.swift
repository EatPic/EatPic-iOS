//
//  CardDeleteResponse.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/20/25.
//

import Foundation

struct MealStatusCardDeleteResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MealStatusCardDeleteResult
}

struct MealStatusCardDeleteResult: Codable {
    let cardId: Int
    let successMessage: String
}
