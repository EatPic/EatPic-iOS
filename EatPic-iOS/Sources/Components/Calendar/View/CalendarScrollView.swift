//
//  CalendarScrollView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import SwiftUI

/// 달력을 무한 스크롤로 여러 달을 연속적으로 보여주는 뷰입니다.
/// 사용자는 상하 스크롤을 통해 여러 달의 캘린더를 탐색할 수 있습니다.
struct CalendarScrollView: View {
    /// 화면에 표시될 월의 배열입니다. 초기에는 현재 월부터 4개월이 로딩됩니다.
    @State private var months: [Date] = {
        let calendar = Calendar.current
        let base = calendar.startOfMonth(for: Date())
        return (0..<4).compactMap {
            calendar.date(byAdding: .month, value: $0, to: base)
        }
    }()

    /// 초기 로딩에서 과거 달을 한 번만 prepend하기 위한 플래그입니다.
    @State private var initialLoadCompleted = false

    /// 현재 사용하는 캘린더 인스턴스입니다.
    private let calendar = Calendar.current

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(months, id: \.self) { month in
                        /// 각 월마다 CalendarView를 렌더링하며,
                        /// onAppear 시에 무한 스크롤 처리를 위한 로직이 실행됩니다.
                        CalendarView(month: month) { selectedDate in
                            print("Selected: \(selectedDate)")
                        }
                        .id(month)
                        .onAppear {
                            reloadData(month: month, proxy: proxy)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
    
    /// 월이 처음 보일 때 이전 월을 prepend하거나,
    /// 마지막 월이 보일 때 다음 월을 추가하는 로직입니다.
    /// - Parameters:
    ///   - month: 현재 onAppear된 월
    ///   - proxy: 스크롤 위치를 제어하기 위한 ScrollViewProxy
    private func reloadData(month: Date, proxy: ScrollViewProxy) {
        if month == months.first,
           months.count < 100, // 무한 루프 방지 조건도 추가
           !initialLoadCompleted {
            initialLoadCompleted = true
            let currentTop = month
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                prependPreviousMonths(to: currentTop) {
                    DispatchQueue.main.async {
                        proxy.scrollTo(currentTop, anchor: .top)
                    }
                }
            }
        } else if month == months.last {
            loadMoreMonths()
        }
    }

    /// 현재 마지막 월 이후의 4개월을 추가합니다.
    private func loadMoreMonths() {
        guard let last = months.last else { return }
        let newMonths = (1...4).compactMap {
            calendar.date(byAdding: .month, value: $0, to: last)
        }
        months.append(contentsOf: newMonths)
    }
    
    /// 현재 첫 월 이전의 4개월을 prepend합니다.
    /// - Parameters:
    ///   - reference: 기준이 되는 날짜 (현재 첫 번째 월)
    ///   - onComplete: prepend 후에 실행될 콜백
    private func prependPreviousMonths(
        to reference: Date,
        onComplete: @escaping () -> Void
    ) {
        let newMonths = (1...4).compactMap {
            calendar.date(byAdding: .month, value: -$0, to: reference)
        }.reversed()
        months.insert(contentsOf: newMonths, at: 0)
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.01, execute: onComplete)
    }
}

private extension Calendar {
    /// 주어진 날짜의 월 시작 날짜를 반환합니다.
    /// - Parameter date: 기준 날짜
    /// - Returns: 해당 날짜가 포함된 월의 시작 날짜
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}

#Preview {
    CalendarScrollView()
}
