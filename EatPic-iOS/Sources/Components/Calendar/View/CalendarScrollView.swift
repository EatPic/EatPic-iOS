//
//  CalendarScrollView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import SwiftUI
import Moya

/// 월(visible month)의 위치를 전달하기 위한 PreferenceKey입니다.
/// - Note:
///   - `value`의 형태는 `[Date: CGFloat]`이며, 키는 **각 월(Date)**, 값은 해당 월의 **Y 오프셋(minY)** 입니다.
///   - 오프셋은 `.coordinateSpace(name: "scroll")` 기준으로 측정되며, **0에 가까울수록 화면 중앙에 가깝다**고 볼 수 있습니다.
///   - 여러 `GeometryReader`에서 들어오는 값을 `reduce`에서 **머지**하여 한 번에 수집합니다.
struct MonthVisiblePreferenceKey: PreferenceKey {
    /// 초기값은 빈 딕셔너리입니다. 월(Date) → 오프셋(CGFloat)
    static var defaultValue: [Date: CGFloat] = [:]

    /// 각 자식 뷰가 보고한 오프셋 맵을 상위로 전달하며 병합합니다.
    /// 동일 월(Date) 키가 중복될 경우, **마지막 리포팅 값으로 갱신**합니다.
    static func reduce(
        value: inout [Date: CGFloat],
        nextValue: () -> [Date: CGFloat]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

/// (연, 월) 조합을 표현하는 경량 키 타입입니다.
/// - Important: `Hashable`을 채택해 Set/Dictionary의 키로 사용합니다.
struct YearMonth: Hashable {
    let year: Int
    let month: Int
}

/// 서버 공통 응답 래퍼입니다.
/// - Parameters:
///   - T: `result` 페이로드 타입(배열/단일 모두 지원).
/// - Tip: 다양한 API에서 **공통 래퍼 재사용**을 위해 제네릭으로 설계되어 있습니다.
struct APIResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}

/// 캘린더 한 항목에 대한 응답 DTO입니다.
/// - Note: `date`는 문자열로 내려오므로, 파싱이 필요하면 별도 매퍼에서 처리하세요.
struct CalendarResponse: Codable {
    let date: String
    let imageUrl: String
    let cardId: Int
}

/// 캘린더 무한 스크롤과 월별 데이터 로딩을 관리하는 뷰모델입니다.
/// - Responsibilities:
///   - `visibleYM` 변화에 맞춰 **월별 데이터 페치**
///   - **중복 호출 방지**: 이미 로드한 월은 `loaded` 캐시로 차단
///   - 네트워크/디코딩은 백그라운드에서 수행, UI 반영만 MainActor에서 처리
@Observable
final class CalendarScrollViewModel {
    /// 홈 모듈용 `MoyaProvider`
    private let homeProvider: MoyaProvider<HomeTargetType>
    /// 이미 성공적으로 로드한 (연, 월) 키 캐시. 중복 호출 방지 용도입니다.
    private var loaded: Set<YearMonth> = []
    
    /// - Parameter container: DI 컨테이너. 여기서 필요한 Provider를 주입받습니다.
    init(container: DIContainer) {
        self.homeProvider = container.apiProviderStore.home()
    }
    
    /// 특정 연/월의 캘린더 데이터를 요청합니다.
    /// - Parameters:
    ///   - year: 연도
    ///   - month: 월
    /// - Important:
    ///   - **중복 호출 방지**: 이미 로드된 `(year, month)`는 재요청하지 않습니다.
    ///   - 네트워크/디코딩은 백그라운드, UI 반영만 필요 시 `MainActor`에서 수행하세요.
    func fetchCalendarData(year: Int, month: Int) async {
        let key = YearMonth(year: year, month: month)
        guard !loaded.contains(key) else { return }
        
        do {
            let response = try await homeProvider.requestAsync(
                .fetchCalendar(year: year, month: month))
            let data = try JSONDecoder().decode(
                APIResponse<[CalendarResponse]>.self, from: response.data)
            
            guard data.isSuccess else {
                throw APIError.server(code: data.code, message: data.message)
            }
            
            // 성공 시, 필요한 상태 업데이트를 메인에서 처리.
            // await MainActor.run { ... }
            loaded.insert(key)
            print(data)
        } catch let error as MoyaError {
            let msg = readable(error)
            print("MoyaError:", msg)
        } catch {
            print("Decode/Other Error:", error.localizedDescription)
        }
    }
    
    /// 사용자/로깅을 위한 읽기 쉬운 에러 메시지를 생성합니다.
    private func readable(_ error: MoyaError) -> String {
        switch error {
        case let .statusCode(res): return "서버 오류(\(res.statusCode))"
        case let .underlying(err, _): return "네트워크 오류: \(err.localizedDescription)"
        default: return "요청 실패: \(error.localizedDescription)"
        }
    }
}

// MARK: - 에러 보조

/// 서버가 `isSuccess = false`로 내려줄 때를 표현하는 에러 타입입니다.
enum APIError: LocalizedError {
    case server(code: String, message: String)
    
    var errorDescription: String? {
        switch self {
        case let .server(code, message):
            return "[\(code)] \(message)"
        }
    }
}

/// 달력을 무한 스크롤로 여러 달을 연속적으로 보여주는 뷰입니다.
/// - Features:
///   - **GeometryReader + PreferenceKey**로 각 월의 화면 내 상대 위치를 보고
///   - `onPreferenceChange`에서 **가장 중앙에 가까운 월**을 계산하여 `visibleYM` 업데이트
///   - `.task(id:)`가 `visibleYM` 변경에 반응해 **월별 데이터를 페치**
///   - 상단 도달 시 **이전 월을 prepend**하여 무한 스크롤 UX 제공
struct CalendarScrollView: View {
    /// 이 뷰가 소유하는 뷰모델(Observation 기반). 수명주기와 함께 관리됩니다.
    @State private var calendarScrollVM: CalendarScrollViewModel
    /// 화면에서 **중앙에 가장 가까운 월**(YearMonth). 데이터 요청 트리거로 사용됩니다.
    @State private var visibleYM: YearMonth?
    @State private var months: [Date]
    @State private var isPrepending = false
    @State private var showLoadingIndicator = false
    @State private var isScrollLimited = false

    private let calendar = Calendar.current
    private let initailMonthCount: Int = 4
    private let reachTopThreshold: CGFloat = 50
    
    /// DI 컨테이너를 받아 초기 월 배열과 뷰모델을 구성합니다.
    /// - Important: 초기 월은 `Calendar.startOfMonth(for:)` 기준으로 산출합니다.
    init(container: DIContainer) {
        let calendar = Calendar.current
        let base = calendar.startOfMonth(for: Date())
        self.months = (0..<initailMonthCount).compactMap {
            calendar.date(byAdding: .month, value: $0, to: base)
        }
        self._calendarScrollVM = State(
            initialValue: .init(container: container)
        )
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
                            /// 각 월마다 캘린더를 렌더링합니다.
                            /// - Note: onAppear에서 prepend 로직을 트리거합니다.
                            CalendarView(month: month) { selectedDate in
                                print("Selected: \(selectedDate)")
                            }
                            .background(alignment: .center) {
                                /// GeometryReader가 **각 월의 프레임**을
                                /// `.coordinateSpace(name: "scroll")` 기준으로 읽어
                                /// `MonthVisiblePreferenceKey`에 보고합니다.
                                ///
                                /// - Why:
                                ///   - 각 월 컨테이너의 **minY(세로 위치)**를 수집하여
                                ///     화면 중앙(0에 가까움)에 가장 근접한 월을 찾기 위함입니다.
                                /// - How:
                                ///   - 각 월(Date)을 키로 하고, `minY`를 값으로 하는 맵을
                                ///     PreferenceKey에 전달 → 상위 뷰에서 한 번에 수집/병합.
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(
                                            key: MonthVisiblePreferenceKey.self,
                                            value: [
                                                month: geo.frame(in: .named("scroll")).minY
                                            ]
                                        )
                                }
                            }
                            .id(month)
                            .onAppear {
                                /// 상단 도달 시 **이전 월들을 prepend**합니다.
                                /// - 중복 호출을 막기 위해 `isPrepending`/`isScrollLimited`로 가드합니다.
                                reloadData(month: month, proxy: proxy)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(MonthVisiblePreferenceKey.self) { values in
                /// PreferenceKey로부터 **월(Date) → minY** 맵을 수신합니다.
                /// - Step1: minY의 **절댓값이 가장 작은** (중앙에 가장 가까운) 월을 선택
                /// - Step2: 해당 월의 Date → (year, month)로 변환
                /// - Step3: `visibleYM`이 바뀌었을 때만 갱신(불필요한 상태 변화를 차단)
                guard let closestMonth = values
                    .min(by: { abs($0.value) < abs($1.value) })?.key else { return }
                
                let comp = calendar.dateComponents([.year, .month], from: closestMonth)
                if let year = comp.year, let month = comp.month {
                    let next = YearMonth(year: year, month: month)
                    if next != visibleYM { // 불필요한 중복 방지
                        visibleYM = next
                    }
                }
            }
        }
        /// `.task(id:)`는 **식별자(id)가 바뀔 때마다** 새로운 비동기 작업을 실행합니다.
        /// - Behavior:
        ///   - `visibleYM`이 변경되면 이전 작업을 **자동 취소**하고 새 작업을 시작합니다.
        ///   - 클로저 타입은 `async` **non-throwing**이므로, 내부에서 `throws`는 처리해야 합니다.
        /// - Why here:
        ///   - 스크롤에 의해 **현재 보이는 월**이 바뀔 때만 네트워크를 호출하여
        ///     불필요한 요청을 줄이고, 사용자 체감 성능을 개선합니다.
        .task(id: visibleYM) {
            guard let yearAndmonth = visibleYM else { return }
            print(yearAndmonth)
            await calendarScrollVM.fetchCalendarData(
                year: yearAndmonth.year, month: yearAndmonth.month)
        }
        .background(Color.white)
        .customCenterNavigationBar {
            Text("캘린더")
                .font(.title2)
                .foregroundStyle(Color.gray080)
        }
    }
    
    /// 월이 처음 보일 때 이전 월을 prepend하여 상단 무한 스크롤 UX를 제공합니다.
    /// - Parameters:
    ///   - month: 현재 `onAppear`가 트리거된 월(Date)
    ///   - proxy: 스크롤 위치 복원을 위한 `ScrollViewProxy`
    /// - Important:
    ///   - `isPrepending`/`isScrollLimited` 플래그로 **중복 트리거**를 방지합니다.
    private func reloadData(month: Date, proxy: ScrollViewProxy) {
        guard !isPrepending, !isScrollLimited else { return }
        
        if month == months.first {
            isPrepending = true
            isScrollLimited = true
            showLoadingIndicator = true
            
            let currentTop = month
            prependPreviousMonths(to: currentTop) {
                DispatchQueue.main.async {
                    // 스크롤 복구 시 생기는 버벅거림 제거를 위해 애니메이션 비활성화
                    withAnimation(.none) {
                        proxy.scrollTo(currentTop, anchor: .top)
                    }
                    isPrepending = false
                    
                    // 상단 도달 시 과도한 스크롤을 막기 위해 잠시 제한
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showLoadingIndicator = false
                        isScrollLimited = false
                    }
                }
            }
        }
        // 하단 무한 스크롤은 EatPic 캘린더 특성상 현재 불필요하다고 판단하여 비활성화
        // else if month == months.last { loadMoreMonths() }
    }

    /// 현재 마지막 월 이후의 `initailMonthCount`개월을 추가합니다.
    /// - Note: 현 시점에서는 사용하지 않지만, 확장성 유지를 위해 남겨둡니다.
    private func loadMoreMonths() {
        guard let last = months.last else { return }
        let newMonths = (1...initailMonthCount).compactMap {
            calendar.date(byAdding: .month, value: $0, to: last)
        }
        months.append(contentsOf: newMonths)
    }
    
    /// 현재 첫 월 이전의 `initailMonthCount`개월을 **prepend** 합니다.
    /// - Parameters:
    ///   - reference: 기준이 되는 날짜(현재 첫 번째 월)
    ///   - onComplete: prepend 후 후속 작업(스크롤 복구 등)
    /// - Important:
    ///   - 빠른 스크롤에서 생길 수 있는 시각적 버벅임을 줄이기 위해 **애니메이션을 제거**합니다.
    private func prependPreviousMonths(
        to reference: Date,
        onComplete: @escaping () -> Void
    ) {
        let newMonths = (1...initailMonthCount).compactMap {
            calendar.date(byAdding: .month, value: -$0, to: reference)
        }.reversed()
        // 빠른 스크롤 시 새로운 월들이 버벅거리며 생기는 문제 제거를 위해 애니메이션 제거
        withAnimation(.none) {
            months.insert(contentsOf: newMonths, at: 0)
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.01, execute: onComplete)
    }
}

private extension Calendar {
    /// 주어진 날짜가 속한 월의 첫날(00:00)을 반환합니다.
    /// - Parameter date: 기준 날짜
    /// - Returns: 해당 날짜가 포함된 월의 시작 날짜
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}

#Preview {
    CalendarScrollView(container: .init())
}
