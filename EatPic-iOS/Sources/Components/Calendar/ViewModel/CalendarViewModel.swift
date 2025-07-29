//
//  CalendarViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import Foundation

/// 캘린더 뷰의 상태와 데이터를 관리하는 ViewModel입니다.
///
/// 현재 월, 선택된 날짜, 이미지 메타 데이터 등을 바탕으로 캘린더 셀을 구성합니다.
@Observable
class CalendarViewModel {
    var currentMonth: Date
    var selectedDate: Date
    private let calendar: Calendar
    private let dateProvider: CalendarDateProviding
    private var metaDict: [Date: EatPicDayMeta] = EatPicDayMeta.dummyByDate

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
            let meta = metaDict[calendar.startOfDay(for: baseDay.date)]
            return CalendarDay(
                day: baseDay.day,
                date: baseDay.date,
                isCurrentMonth: baseDay.isCurrentMonth,
                meta: meta
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
}
