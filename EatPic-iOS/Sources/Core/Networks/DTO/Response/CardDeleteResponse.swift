//
//  CardDeleteResponse.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/14/25.
//

import Foundation

struct CardDeleteResult: Codable {
    let cardId: Int
    let successMessage: String
}
