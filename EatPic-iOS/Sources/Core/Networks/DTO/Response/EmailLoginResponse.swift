//
//  EmailLoginResponse.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/11/25.
//

import Foundation

/// 이메일로 로그인 응답 구조체
struct EmailLoginResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserInfo
}
