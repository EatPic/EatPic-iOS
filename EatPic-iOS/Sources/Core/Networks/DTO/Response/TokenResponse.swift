//
//  TokenResponse.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/18/25.
//

import Foundation

/// 서버로부터 전달받은 토큰 갱신 응답을 디코딩하기 위한 모델입니다.
/// - Parameters:
///   - isSuccess: 요청 성공 여부를 나타냅니다.
///   - code: 서버에서 정의한 응답 코드입니다.
///   - message: 응답에 대한 설명 메시지입니다.
///   - result: 갱신된 사용자 정보(UserInfo)를 포함합니다.
struct TokenResponse: Codable {
    // TODO: [25.07.21 - 리버/이재원] 실제 서버 응답값과 일치시켜야 함
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LoginResult
}
