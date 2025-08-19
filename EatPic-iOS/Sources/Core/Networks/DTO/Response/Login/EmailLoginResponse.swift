//
//  EmailLoginResponse.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/11/25.
//

import Foundation

/// 이메일로 로그인 응답 구조체
struct LoginResult: Codable {
    let role: String
    let userId: Int
    let email: String
    let accessToken: String
    let refreshToken: String
}
