//
//  CalendarDateProviding.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import Foundation

/// 캘린더에 표시할 날짜들을 생성하는 기능을 정의하는 프로토콜입니다.
protocol CalendarDateProviding {
    func generateBaseDays(for month: Date) -> [CalendarDay]
    func numberOfDays(in date: Date) -> Int
}
