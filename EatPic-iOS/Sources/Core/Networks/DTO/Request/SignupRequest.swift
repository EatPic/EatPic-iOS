//
//  SignupRequest.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/9/25.

import Foundation

/// 회원가입 API 요청 구조체
struct SignupRequest: Codable {
    let role: String
    let email: String
    let password: String
    let passwordConfirm: String
    let nameId: String
    let nickname: String
    let termsAgreed: Bool
    let privacyPolicyAgreed: Bool
    let marketingAgreed: Bool
    let notificationAgreed: Bool
}
