//
//  EmailLoginRequest.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/11/25.
//

import Foundation

/// 이메일 로그인 요청 구조체
struct EmailLoginRequest: Codable {
    let email: String
    let password: String
}
