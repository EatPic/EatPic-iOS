//
//  GreetingResponse.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/14/25.
//

import Foundation

/// 홈화면 인사말 응답 구조체


/// 홈화면 진입시 인사 타이틀 모델
struct GreetingResponse: Codable {
    let name: String
    let message: String
}
