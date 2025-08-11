//
//  APIError.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/11/25.
//

import Foundation

// MARK: - 에러 보조

/// 서버가 `isSuccess = false`로 내려줄 때를 표현하는 에러 타입입니다.
enum APIError: LocalizedError {
    case server(code: String, message: String)
    
    var errorDescription: String? {
        switch self {
        case let .server(code, message):
            return "[\(code)] \(message)"
        }
    }
}
