//
//  HashtagPolicyError.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/14/25.
//

import Foundation

enum HashtagPolicyError: LocalizedError {
    case tooLongHangul(limit: Int)
    case empty
    case duplicateTitle
    // 추후 확장
    
    var errorDescription: String? {
        switch self {
        case .empty: return "내용을 입력해 주세요."
        case .tooLongHangul(let limit):
            return "최대 \(limit)글자까지 입력 가능합니다."
        case .duplicateTitle:
            return "이미 존재하는 해시태그입니다."
        }
    }
}
