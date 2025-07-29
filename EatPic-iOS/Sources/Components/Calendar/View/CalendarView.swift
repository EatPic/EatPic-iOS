//
//  CalendarView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/27/25.
//

import SwiftUI

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
