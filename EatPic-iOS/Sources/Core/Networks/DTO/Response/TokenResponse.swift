//
//  TokenResponse.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/18/25.
//

import Foundation

struct TokenResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserInfo
}
