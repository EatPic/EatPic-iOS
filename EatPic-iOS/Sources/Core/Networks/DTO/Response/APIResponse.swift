//
//  APIResponse.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/11/25.
//

import Foundation

/// 서버 공통 응답 래퍼입니다.
/// - Parameters:
///   - T: `result` 페이로드 타입(배열/단일 모두 지원).
/// - Tip: 다양한 API에서 **공통 래퍼 재사용**을 위해 제네릭으로 설계되어 있습니다.
struct APIResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}
