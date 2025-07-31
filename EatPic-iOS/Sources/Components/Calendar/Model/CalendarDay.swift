//
//  CalendarDay.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import Foundation

/// 캘린더 셀 하나를 나타내는 모델입니다.
///
/// 각 날짜에 대한 정보와 현재 월 여부, 이미지 메타 정보를 포함합니다.
struct CalendarDay: Identifiable {
    var id: UUID = .init()
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
    var meta: EatPicDayMeta?
}
