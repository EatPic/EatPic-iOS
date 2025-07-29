//
//  CalendarView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/27/25.
//

import SwiftUI

struct EatPicDayMeta {
    var img: Image?
}

struct CalendarDay: Identifiable {
    var id: UUID = .init()
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
    var meta: EatPicDayMeta?
}

protocol CalendarDateProviding {
    func generateDays(for month: Date) -> [CalendarDay]
    func numberOfDays(in date: Date) -> Int
}

protocol CalendarUseCase {
    func hasImage(for date: Date) -> Bool
    func fetchImages(for month: Date) async throws -> [Date: Image]
}

// MARK: - EatPicCalendarUseCase Implementation
final class EatPicCalendarUseCase: CalendarUseCase {
    private var imageStore: [Date: Image] = [:]
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func hasImage(for date: Date) -> Bool {
        imageStore.keys.contains {
            calendar.isDate($0, inSameDayAs: date)
        }
    }

    func fetchImages(for month: Date) async throws -> [Date: Image] {
        // TODO: [25.07.29] 실제 이미지를 불러오는 로직으로 변경 필요 - 리버/이재원
        var results: [Date: Image] = [:]
        var components = calendar.dateComponents([.year, .month], from: month)
        components.day = 10

        if let targetDate = calendar.date(from: components) {
            results[targetDate] = Image(systemName: "photo")
        }

        imageStore = results
        return results
    }
}

final class CalendarDateProvider: CalendarDateProviding {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func generateDays(for month: Date) -> [CalendarDay] {
        var days: [CalendarDay] = []
        days.append(contentsOf: makeLeadingDays(month))
        days.append(contentsOf: makeCurrentMonthDays(month))
        days.append(contentsOf: makeTrailingDays(startCount: days.count, month: month))
        return days
    }

    func numberOfDays(in date: Date) -> Int {
        calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }

    private func firstDayOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? Date()
    }

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

@Observable
class CalendarViewModel {
    var currentMonth: Date
    var selectedDate: Date
    private let calendar: Calendar
    private let dateProvider: CalendarDateProviding
    private let calendarUseCase: CalendarUseCase
    
    init(
        currentMonth: Date = Date(),
        selectedDate: Date = Date(),
        calendar: Calendar = .current,
        dateProvider: CalendarDateProviding = CalendarDateProvider(),
        calendarUseCase: CalendarUseCase
    ) {
        self.currentMonth = currentMonth
        self.selectedDate = selectedDate
        self.calendar = calendar
        self.dateProvider = dateProvider
        self.calendarUseCase = calendarUseCase
    }
    
    var days: [CalendarDay] {
        dateProvider.generateDays(for: currentMonth)
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(
            byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
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
    
    func hasImage(for date: Date) -> Bool {
        calendarUseCase.hasImage(for: date)
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
    
    @State var viewModel: CalendarViewModel = .init(
        calendarUseCase: EatPicCalendarUseCase())
    
    private let cellTapAction: () -> Void
    
    init(cellTapAction: @escaping () -> Void) {
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
            .padding(.bottom, 23) // 요일 아래 여백
            
            // 날짜
            ForEach(
                viewModel.days,
                id: \.id
            ) { calendarDay in
                Button {
                    print("\(calendarDay.date)")
                    cellTapAction()
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
    CalendarView(cellTapAction: {
        print("cellTapAction")
    })
}
