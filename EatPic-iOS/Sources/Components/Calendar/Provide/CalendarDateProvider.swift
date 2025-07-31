//
//  CalendarDateProvider.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import Foundation

/// 실제 캘린더 날짜 계산 로직을 구현하는 클래스입니다.
///
/// 현재 월 기준 날짜들, 이전/다음 월 포함하여 캘린더에 필요한 전체 날짜 배열을 구성합니다.
final class CalendarDateProvider: CalendarDateProviding {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func generateBaseDays(for month: Date) -> [CalendarDay] {
        var days: [CalendarDay] = []
        days.append(contentsOf: makeLeadingDays(month))
        days.append(contentsOf: makeCurrentMonthDays(month))
        days.append(
            contentsOf: makeTrailingDays(startCount: days.count, month: month))
        return days
    }

    func numberOfDays(in date: Date) -> Int {
        calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }

    /// 주어진 날짜의 월 시작 날짜를 계산합니다.
    private func firstDayOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? Date()
    }

    /// 현재 월 이전의 날짜들(앞쪽 공백 채우기용)을 생성합니다.
    private func makeLeadingDays(_ currentMonth: Date) -> [CalendarDay] {
        let firstDay = firstDayOfMonth(for: currentMonth)
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let leadingDays = (firstWeekday - calendar.firstWeekday + 7) % 7

        guard leadingDays > 0,
              let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)
        else { return [] }

        let daysInPreviousMonth = numberOfDays(in: previousMonth)

        return (0..<leadingDays).compactMap { idx in
            let day = daysInPreviousMonth - leadingDays + 1 + idx
            guard let date = calendar.date(
                bySetting: .day, value: day, of: previousMonth) else {
                return nil
            }
            return CalendarDay(day: day, date: date, isCurrentMonth: false)
        }
    }

    /// 현재 월의 날짜들을 생성합니다.
    private func makeCurrentMonthDays(_ currentMonth: Date) -> [CalendarDay] {
        let daysInMonth = numberOfDays(in: currentMonth)

        return (1...daysInMonth).compactMap { day in
            var components = calendar.dateComponents([.year, .month], from: currentMonth)
            components.day = day
            components.hour = 0
            components.minute = 0
            components.second = 0
            guard let date = calendar.date(from: components) else { return nil }
            return CalendarDay(day: day, date: date, isCurrentMonth: true)
        }
    }

    /// 현재 월 이후의 날짜들(뒤쪽 공백 채우기용)을 생성합니다.
    private func makeTrailingDays(startCount: Int, month: Date) -> [CalendarDay] {
        let remaining = (7 - startCount % 7) % 7
        guard remaining > 0,
              let nextMonth = calendar.date(byAdding: .month, value: 1, to: month)
        else { return [] }

        let daysInNextMonth = numberOfDays(in: nextMonth)

        return (1...remaining).compactMap { day in
            let validDay = min(day, daysInNextMonth)
            guard let date = calendar.date(
                bySetting: .day, value: validDay, of: nextMonth) else {
                return nil
            }
            return CalendarDay(day: validDay, date: date, isCurrentMonth: false)
        }
    }
}
