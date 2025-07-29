//
//  CalendarScrollView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import SwiftUI

/// 달력을 무한 스크롤로 여러 달을 연속적으로 보여주는 뷰
struct CalendarScrollView: View {
    @State private var months: [Date] = {
        let calendar = Calendar.current
        let base = calendar.startOfMonth(for: Date())
        return (0..<4).compactMap {
            calendar.date(byAdding: .month, value: $0, to: base)
        }
    }()
    @State private var initialLoadCompleted = false

    private let calendar = Calendar.current

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(months, id: \.self) { month in
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

    private func loadMoreMonths() {
        guard let last = months.last else { return }
        let newMonths = (1...4).compactMap {
            calendar.date(byAdding: .month, value: $0, to: last)
        }
        months.append(contentsOf: newMonths)
    }
    
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
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}

#Preview {
    CalendarScrollView()
}
