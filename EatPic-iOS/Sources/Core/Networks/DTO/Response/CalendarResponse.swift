//
//  CalendarResponse.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/11/25.
//

import Foundation

/// 캘린더 한 항목에 대한 응답 DTO입니다.
/// - Note: `date`는 문자열로 내려오므로, 파싱이 필요하면 별도 매퍼에서 처리하세요.
struct CalendarResponse: Codable {
    let date: String
    let imageUrl: String
    let cardId: Int
}
