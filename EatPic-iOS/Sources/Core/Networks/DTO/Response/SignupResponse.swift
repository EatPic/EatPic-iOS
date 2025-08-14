//
//  SignupResponse.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/11/25.
//

import Foundation

/// 이메일 회원가입 API 응답 구조체
struct SignupResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SignupResult
}

struct SignupResult: Codable {
    let role: String
    let userId: Int
    let email: String
    let nameId: String
    let nickname: String
    let marketingAgreed: Bool
    let notificationAgreed: Bool
}
