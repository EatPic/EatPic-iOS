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
    
    /// 셀 렌더링용: 날짜별 이미지 메타
    var metaByDate: [Date: EatPicDayMeta] = [:]
    
    /// - Parameter container: DI 컨테이너. 여기서 필요한 Provider를 주입받습니다.
    init(container: DIContainer) {
        self.homeProvider = container.apiProviderStore.home()
    }
    
    // MARK: - Func
    
    // 서버 "yyyy-MM-dd" 파서
    private static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // 날짜 문자열만이므로 UTC로 파싱
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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
            let dto = try JSONDecoder().decode(
                APIResponse<[CalendarResponse]>.self, from: response.data)
            guard dto.isSuccess else {
                throw APIError.serverError(
                    code: response.statusCode,
                    message: dto.message)
            }
            
            // 1) 백그라운드에서 병합 계산
            var merged = self.metaByDate
            let cal = Calendar.current
            for item in dto.result {
                guard let date = Self.yyyyMMdd.date(from: item.date) else {
                    continue
                }
                let dayKey = cal.startOfDay(for: date) // 로컬 자정으로 정규화
                merged[dayKey] = EatPicDayMeta(
                    imageURL: item.imageUrl,
                    cardId: item.cardId
                )
            }
            
            // 2) await 전에 불변 스냅샷 생성
            let resultMap = merged
            let loadedKey = key
            
            // 3) MainActor에서 UI 상태 갱신
            await MainActor.run {
                self.metaByDate = resultMap
                self.loaded.insert(loadedKey) // 성공 시에만 markLoaded
            }
            print("캘린더 API 호출 성공🟢")
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
        case let .underlying(
            err,
            _
        ): return "네트워크 오류: \(err.localizedDescription)"
        default: return "요청 실패: \(error.localizedDescription)"
        }
    }
}
