//
//  GreetingResponse.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/14/25.
//

import Foundation

/// 홈화면 인사말 응답 구조체
struct GreetingResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: GreetingResult
}

struct GreetingResult: Codable {
    let nickname: String
    let message: String
}
