//
//  CalendarScrollViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/10/25.
//

import Foundation
import Moya

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
                throw APIError.serverError(code: response.statusCode, message: data.message)
            }
            
            await markLoaded(key)
            print(data.result) // 추후 실제 api 연결시 ui 연결 예정 - 리버/이재원
        } catch let error as MoyaError {
            let msg = readable(error)
            print("MoyaError:", msg)
        } catch {
            print("Decode/Other Error:", error.localizedDescription)
        }
    }
    
    @MainActor
    private func markLoaded(_ key: YearMonth) {
        loaded.insert(key)
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
