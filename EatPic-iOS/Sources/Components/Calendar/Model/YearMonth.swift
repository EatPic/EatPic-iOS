//
//  YearMonth.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/11/25.
//

import Foundation

/// (연, 월) 조합을 표현하는 경량 키 타입입니다.
/// - Important: `Hashable`을 채택해 Set/Dictionary의 키로 사용합니다.
struct YearMonth: Hashable {
    let year: Int
    let month: Int
}
