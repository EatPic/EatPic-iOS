//
//  CalendarView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/27/25.
//

import SwiftUI

/// 캘린더 셀에 표시할 이미지 데이터를 포함하는 메타 정보 구조체입니다.
///
/// - Parameters:
///   - img: 해당 날짜에 연결된 이미지. 없을 수도 있습니다.
struct EatPicDayMeta {
    var img: Image?
}

extension EatPicDayMeta {
    /// 날짜별 더미 이미지 메타 정보를 제공합니다.
    ///
    /// 오늘 날짜와 그 다음 날에 대해 `EatPicDayMeta`를 포함하는 임시 데이터를 반환합니다.
    /// API 연동 전까지 셀에 이미지를 렌더링할 목적으로 사용됩니다.
    ///
    /// - Returns: `Date`를 키로 하고, 해당 날짜의 `EatPicDayMeta`를 값으로 갖는 딕셔너리
    static var dummyByDate: [Date: EatPicDayMeta] {
        let calendar = Calendar.current
        var result: [Date: EatPicDayMeta] = [:]

        // 예시: 오늘과 오늘 + 1일 뒤에 이미지 존재
        let today = calendar.startOfDay(for: Date())
        
        if let future = calendar.date(byAdding: .day, value: 1, to: today) {
            result[today] = EatPicDayMeta(img: Image(.Calendar.img))
            result[future] = EatPicDayMeta(img: Image(.Calendar.img))
        }

        return result
    }
}

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

/// 캘린더에 표시할 날짜들을 생성하는 기능을 정의하는 프로토콜입니다.
protocol CalendarDateProviding {
    func generateBaseDays(for month: Date) -> [CalendarDay]
    func numberOfDays(in date: Date) -> Int
}

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

struct Cell: View {
    
    var calendarDay: CalendarDay
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
        ZStack {
            if let image = calendarDay.meta?.img {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 43, height: 43)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Rectangle()
                    .fill(rectangleFillColor)
                    .frame(width: 43, height: 43)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Text("\(calendarDay.day)")
                .font(.dsHeadline)
                .foregroundStyle(textColor)
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDate)
        }
        .frame(height: 50)
    }
    
    private var textColor: Color {
        if calendarDay.meta?.img != nil {
            return Color.white
        } else {
            if calendarDay.isCurrentMonth {
                return Color.gray080
            } else {
                return Color.gray080.opacity(0.2)
            }
        }
    }
    
    private var rectangleFillColor: Color {
        if calendarDay.isCurrentMonth {
            return Color.gray020
        } else {
            return Color.gray020.opacity(0.2)
        }
    }
}

struct CalendarView: View {
    
    @State var viewModel: CalendarViewModel
    
    private let cellTapAction: (Date) -> Void
    
    init(
        month: Date,
        cellTapAction: @escaping (Date) -> Void
    ) {
        self.viewModel = .init(currentMonth: month)
        self.cellTapAction = cellTapAction
    }
    
    var body: some View {
        VStack(spacing: 24, content: {
            hedarController // 상단 월 변경 컨트롤러
            
            calendarView // 달력 본체
        })
        .padding(.vertical, 30)
        .padding(.horizontal, 16)
        .background(Color.white)
    }
    
    /// 상단 월 변경 컨틀롤러 뷰
    private var hedarController: some View {
        Text(
            viewModel.currentMonth,
            formatter: calendarHeaderDateFormatter
        )
        .font(.dsTitle2)
        .foregroundStyle(Color.black)
    }
    
    /// 달력 본체 뷰
    private var calendarView: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 0), count: 7),
            spacing: 5,
            content: {
            /// 요일 헤더 (일 ~ 토)
            ForEach(localizedWeekdaySymbols.indices, id: \.self) { index in
                Text(localizedWeekdaySymbols[index])
                    .foregroundStyle(
                        index == 0 // 일요일
                        ? Color.red
                        : index == 6 // 토요일
                        ? Color.blue
                        : Color.black
                    ) // 일요일, 토요일, 평일 색 따로 두기
                    .frame(maxWidth: .infinity)
                    .font(.dsFootnote)
            }
            .padding(.bottom, 23) // 요일 아래 여백
            
            // 날짜
            ForEach(
                viewModel.days,
                id: \.id
            ) { calendarDay in
                Button {
                    cellTapAction(calendarDay.date)
                } label: {
                    Cell(
                        calendarDay: calendarDay,
                        viewModel: viewModel
                    )
                }
            }
        })
        .frame(height: 250, alignment: .top)
    }
    
    /// 요일 이름 한글로 가져오기
    private let localizedWeekdaySymbols: [String] = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.shortWeekdaySymbols ?? []
    }()
    
    /// 헤더 날짜 표시 포맷터
    private let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    // 아시아/서울 시각으로 날짜 표시
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
}

#Preview {
    CalendarView(month: .now) { _ in
        print("cellTap")
    }
}
