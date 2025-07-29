//
//  CalendarView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/27/25.
//

import SwiftUI

struct CalendarDay: Identifiable {
    var id: UUID = .init()
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
}

@Observable
class CalendarViewModel {
    var currentMonth: Date
    var selectedDate: Date
    var calendar: Calendar
    
    var currentMonthYear: Int {
        Calendar.current.component(.year, from: currentMonth)
    }
    
    init(
        currentMonth: Date = Date(),
        selectedDate: Date = Date(),
        calendar: Calendar = .current
    ) {
        self.currentMonth = currentMonth
        self.selectedDate = selectedDate
        self.calendar = calendar
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    /// 입력된 date가 속한 해당 달의 총 일 수를 반환합니다.
    /// - Parameter date: date 입력
    /// - Returns: 총 일 수 반환
    func numberOfDays(in date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 입력된 date가 속한 달의 첫 번째 날짜가 무슨 요일에 시작하는지 구합니다.
    /// - Parameter date: date 입력
    /// - Returns: 요일 값을 반환합니다. 일요일 = 1, 월요일 = 2 ....
    private func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        guard let firstDay = Calendar.current.date(from: components) else {
            return 0
        }
        return Calendar.current.component(.weekday, from: firstDay)
    }
    
    /// 주어진 date가 속한 일주일 범위의 Date 배열을 반환합니다. weekDay를 기준으로 그 주의 일요일부터 토요일까지 계산합니다.
    /// - Returns: 현재 보고 있는 달의 1일 날짜 반환합니다.
    func firstDayOfMonth() -> Date {
        let compoents = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        return Calendar.current.date(from: compoents) ?? Date()
    }
    
    func daysForCurrentGrid() -> [CalendarDay] {
        var days: [CalendarDay] = []
        days.append(contentsOf: makeLeadingDays())
        days.append(contentsOf: makeCurrentMonthDays())
        days.append(contentsOf: makeTrailingDays(totalCount: days.count))
        return days
    }
    
    /// 사용자가 날짜를 선택했을 때, 기존 선택된 날짜와 비교하여 필요할 경우에만 선택 날짜를 갱신할 수 있도록 합니다. 달력 앱에서 불필요한 상태 업데이트를 방지하고, 성능을 높이기 위해 자주 사용하는 방식이에요!
    /// - Parameter date: 선택한 날짜 업데이트
    public func changeSelectedDate(_ date: Date) {
        if calendar.isDate(selectedDate, inSameDayAs: date) {
            return
        } else {
            selectedDate = date
        }
    }
}

private extension CalendarViewModel {
    func makeLeadingDays() -> [CalendarDay] {
        let firstDay = firstDayOfMonth()
        let firstWeekDay = calendar.component(.weekday, from: firstDay)
        let leadingDays = (firstWeekDay - calendar.firstWeekday + 7) % 7
        
        guard leadingDays > 0,
              let previousMonth = calendar.date(
                byAdding: .month, value: -1, to: currentMonth
              ) else { return [] }
        
        let daysInPreviousMonth = numberOfDays(in: previousMonth)
        
        return (0..<leadingDays).compactMap { idx in
            let day = daysInPreviousMonth - leadingDays + 1 + idx
            guard let date = calendar.date(bySetting: .day, value: day, of: previousMonth) else {
                return nil
            }
            return CalendarDay(day: day, date: date, isCurrentMonth: false)
        }
    }
    
    func makeCurrentMonthDays() -> [CalendarDay] {
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
    
    func makeTrailingDays(totalCount: Int) -> [CalendarDay] {
        let remaining = (7 - totalCount % 7) % 7
        guard remaining > 0,
              let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) else {
            return []
        }
        
        let daysInNextMonth = numberOfDays(in: nextMonth)
        
        return (1...remaining).compactMap { day in
            let validDay = min(day, daysInNextMonth)
            guard let date = calendar.date(bySetting: .day, value: validDay, of: nextMonth) else {
                return nil
            }
            return CalendarDay(day: validDay, date: date, isCurrentMonth: false)
        }
    }
}

struct Cell: View {
    
    var calendarDay: CalendarDay
    var isSelected: Bool
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(rectangleFillColor)
                .frame(width: 43, height: 43)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("\(calendarDay.day)")
                .font(.dsHeadline)
                .foregroundStyle(textColor)
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDate)
        }
        .frame(height: 50)
    }
    
    private var textColor: Color {
        if calendarDay.isCurrentMonth {
            return Color.gray080
        } else {
            return Color.gray080.opacity(0.2)
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
    
    @Bindable var viewModel: CalendarViewModel = .init()
    
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
        HStack(spacing: 47, content: {
            Button(action: {
                viewModel.changeMonth(by: -1)
            }, label: {
                Image(systemName: "chevron.left")
            })
            
            Text(
                viewModel.currentMonth,
                formatter: calendarHeaderDateFormatter
            )
                .font(.dsTitle2)
                .foregroundStyle(Color.black)
            
            Button(action: {
                viewModel.changeMonth(by: 1)
            }, label: {
                Image(systemName: "chevron.right")
            })
        })
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
            .padding(.bottom, 30) // 요일 아래 여백
            
            ForEach(
                viewModel.daysForCurrentGrid(),
                id: \.id
            ) { calendarDay in
                let isSelectedDate = viewModel.calendar.isDate(
                    calendarDay.date,
                    inSameDayAs: viewModel.selectedDate
                )
                Button {
                    print("\(calendarDay.date)")
                } label: {
                    Cell(
                        calendarDay: calendarDay,
                        isSelected: isSelectedDate,
                        viewModel: viewModel
                    )
                }


            }
        })
        .frame(height: 250, alignment: .top)
    }
    
    /// 요일 이름 한글로 가져오기
    let localizedWeekdaySymbols: [String] = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.shortWeekdaySymbols ?? []
    }()
    
    /// 헤더 날짜 표시 포맷터
    let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
}

#Preview {
    CalendarView()
}
