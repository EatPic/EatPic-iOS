//
//  CalendarScrollView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import SwiftUI

struct MonthVisiblePreferenceKey: PreferenceKey {
    static var defaultValue: [Date: CGFloat] = [:]

    static func reduce(value: inout [Date: CGFloat], nextValue: () -> [Date: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

/// 달력을 무한 스크롤로 여러 달을 연속적으로 보여주는 뷰입니다.
/// 사용자는 상하 스크롤을 통해 여러 달의 캘린더를 탐색할 수 있습니다.
struct CalendarScrollView: View {
    /// 화면에 표시될 월의 배열입니다. 초기에는 현재 월부터 `initailMonthCount`개월이 로딩됩니다.
    @State private var months: [Date]
    /// 초기 로딩에서 onAppear 중복 호출 방지하기 위한 플래그
    @State private var isPrepending = false
    @State private var showLoadingIndicator = false
    @State private var isScrollLimited = false

    /// 현재 사용하는 캘린더 인스턴스입니다.
    private let calendar = Calendar.current
    private let initailMonthCount: Int = 4
    private let reachTopThreshold: CGFloat = 50
    
    init() {
        let calendar = Calendar.current
        let base = calendar.startOfMonth(for: Date())
        self.months = (0..<initailMonthCount).compactMap {
            calendar.date(byAdding: .month, value: $0, to: base)
        }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    if showLoadingIndicator {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(Color.gray060)
                            .padding(.bottom, 8)
                    }
                    
                    LazyVStack(spacing: 32) {
                        ForEach(months, id: \.self) { month in
                            /// 각 월마다 CalendarView를 렌더링하며,
                            /// onAppear 시에 무한 스크롤 처리를 위한 로직이 실행됩니다.
                            CalendarView(month: month) { selectedDate in
                                print("Selected: \(selectedDate)")
                            }
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(
                                            key: MonthVisiblePreferenceKey.self,
                                            value: [
                                                month: geo.frame(in: .named("scroll")).minY
                                            ]
                                        )
                                }
                            )
                            .id(month)
                            .onAppear {
                                reloadData(month: month, proxy: proxy)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(MonthVisiblePreferenceKey.self) { values in
                guard let firstMonth = months.first,
                      let firstMonthY = values[firstMonth] else { return }
                
                // `reachTopThreshold`보다 firstMonth의 Y값이 크면 스크롤 상단에 도달한 것으로 판단
                if firstMonthY > -reachTopThreshold, !isPrepending, !isScrollLimited {
                    reloadData(month: firstMonth, proxy: proxy)
                }
            }
            // 스크롤뷰 자체에도 애니메이션을 제거하여 빠른 스크롤 시 버벅거림 제거
            .transaction { $0.disablesAnimations = true }
        }
        .background(Color.white)
        .customCenterNavigationBar {
            Text("캘린더")
                .font(.title2)
                .foregroundStyle(Color.gray080)
        }
    }
    
    /// 월이 처음 보일 때 이전 월을 prepend하거나,
    /// 마지막 월이 보일 때 다음 월을 추가하는 로직입니다.
    /// - Parameters:
    ///   - month: 현재 onAppear된 월
    ///   - proxy: 스크롤 위치를 제어하기 위한 ScrollViewProxy
    private func reloadData(month: Date, proxy: ScrollViewProxy) {
        guard !isPrepending, !isScrollLimited else { return }
        
        if month == months.first {
            isPrepending = true
            isScrollLimited = true
            showLoadingIndicator = true
            
            let currentTop = month
            prependPreviousMonths(to: currentTop) {
                DispatchQueue.main.async {
                    // 스크롤 복구시 생기는 버벅거림을 제거하기 위해 애니메이션 비활성화
                    withAnimation(.none) {
                        proxy.scrollTo(currentTop, anchor: .top)
                    }
                    isPrepending = false
                    
                    // 상단 도달시 무분별한 스크롤 방지를 위한 `ProgressView` 실행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showLoadingIndicator = false
                        isScrollLimited = false
                    }
                }
            }
        }
        // 하단 무한 스크롤은 잇픽 캘린더 뷰 특성상 필요없다고 판단 - 리버/이재원
//        else if month == months.last {
//            loadMoreMonths()
//        }
    }

    /// 현재 마지막 월 이후의 `initailMonthCount`개월을 추가합니다.
    private func loadMoreMonths() {
        guard let last = months.last else { return }
        let newMonths = (1...initailMonthCount).compactMap {
            calendar.date(byAdding: .month, value: $0, to: last)
        }
        months.append(contentsOf: newMonths)
    }
    
    /// 현재 첫 월 이전의 `initailMonthCount`개월을 prepend합니다.
    /// - Parameters:
    ///   - reference: 기준이 되는 날짜 (현재 첫 번째 월)
    ///   - onComplete: prepend 후에 실행될 콜백
    private func prependPreviousMonths(
        to reference: Date,
        onComplete: @escaping () -> Void
    ) {
        let newMonths = (1...initailMonthCount).compactMap {
            calendar.date(byAdding: .month, value: -$0, to: reference)
        }.reversed()
        // 빠른 스크롤시 새로운 월들이 버벅거리며 생기는 문제 제거를 위해 애니메이션 제거
        withAnimation(.none) {
            months.insert(contentsOf: newMonths, at: 0)
        }
        
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
