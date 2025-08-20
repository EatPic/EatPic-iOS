//
//  CalendarViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import SwiftUI

/// 캘린더 뷰의 상태와 데이터를 관리하는 ViewModel입니다.
///
/// 현재 월, 선택된 날짜, 이미지 메타 데이터 등을 바탕으로 캘린더 셀을 구성합니다.
@Observable
class CalendarViewModel {
    var currentMonth: Date
    var selectedDate: Date
    private let calendar: Calendar
    private let dateProvider: CalendarDateProviding
    private var metaDict: [Date: EatPicDayMeta] = [:]

    init(
        currentMonth: Date = Date(),
        selectedDate: Date = Date(),
        calendar: Calendar = .current,
        dateProvider: CalendarDateProviding = CalendarDateProvider()
    ) {
        self.currentMonth = currentMonth
        self.selectedDate = selectedDate
        self.calendar = calendar
        self.dateProvider = dateProvider
    }

    var days: [CalendarDay] {
        dateProvider.generateBaseDays(for: currentMonth).map { baseDay in
            let key = calendar.startOfDay(for: baseDay.date)
            return CalendarDay(
                day: baseDay.day,
                date: baseDay.date,
                isCurrentMonth: baseDay.isCurrentMonth,
                meta: metaDict[key] // ← URL/meta 바인딩
            )
        }
    }
    
    /// 이미지 메타 정보를 외부에서 주입받아 갱신합니다.
    ///
    /// - Parameter newMeta: 날짜별 이미지 메타 정보
    func updateMeta(_ newMeta: [Date: EatPicDayMeta]) {
        self.metaDict = newMeta
    }

    /// 월을 변경합니다.
    ///
    /// - Parameter value: 현재 월 기준으로 더하거나 뺄 개월 수 (예: -1이면 이전 달)
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(
            byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    /// 사용자가 날짜를 선택했을 때 선택된 날짜를 갱신합니다.
    ///
    /// - Parameter date: 선택된 날짜
    public func changeSelectedDate(_ date: Date) {
        if !calendar.isDate(selectedDate, inSameDayAs: date) {
            selectedDate = date
        }
    }
    
    /// 특정 날짜에 해당하는 이미지 URL을 반환합니다.
    ///
    /// - Parameter date: 조회할 날짜
    /// - Returns: 이미지 URL이 있을 경우 해당 이미지, 없으면 nil
    func image(for date: Date) -> String? {
        metaDict[calendar.startOfDay(for: date)]?.imageURL
    }

    /// 특정 날짜에 이미지가 있는지 여부를 반환합니다.
    ///
    /// - Parameter date: 조회할 날짜
    /// - Returns: 이미지 존재 여부
    func hasImage(for date: Date) -> Bool {
        if let url = image(for: date) { return !url.isEmpty }
                return false
    }
}
