//
//  HashtagRecordModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation

// 해시태그 추가 시 중복 해시태그 추가 방지 로직 작성해야함

// MARK: - Catalog (Data-driven)

enum HashtagOrigin: Sendable { case builtIn, custom, remote }

/// 해시태그의 데이터 모델
///
/// - Note: `id`는 서버 코드나 영속 키 사용(서비스에 의해 제공되는 고정 문자열).
/// 런타임에 사용자 정의 태그를 추가해도 충돌 없이 동작합니다.
struct HashtagCategory: Identifiable, Hashable, Sendable {
    let id: String
    var title: String
    var origin: HashtagOrigin = .builtIn
}

/// 해시태그 목록 소스(내장/원격/로컬 합성 가능)
protocol HashtagCatalogProviding: Sendable {
    var all: [HashtagCategory] { get }
}

struct DefaultHashtagCatalog: HashtagCatalogProviding {
    var all: [HashtagCategory] {
        [
            .init(id: "midnightSnack", title: "야식"),
            .init(id: "brunch", title: "브런치"),
            .init(id: "eatingAlone", title: "혼밥"),
            .init(id: "homeMeal", title: "집밥"),
            .init(id: "dietControl", title: "식단관리"),
            .init(id: "selfCooking", title: "자취생"),
            .init(id: "health", title: "건강"),
            .init(id: "gourmet", title: "맛집"),
            .init(id: "vegan", title: "비건"),
            .init(id: "korean", title: "한식"),
            .init(id: "western", title: "양식"),
            .init(id: "chinese", title: "중식"),
            .init(id: "japanese", title: "일식")
        ]
    }
}

/// 해시태그 선택 상태를 나타내는 개별 단위 모델.
///
/// - Parameters:
///   - id: 해시태그 종류(`HashtagKind`)
///   - selected: 현재 선택 여부
///   - selectedAt: 선택 시각 (선택 해제 시 `nil`)
struct HashtagCheck: Sendable {
    let hashtag: HashtagCategory
    var selected: Bool
    var selectedAt: Date?
    
    init(hashtag: HashtagCategory, selected: Bool = false, selectedAt: Date? = nil) {
        self.hashtag = hashtag
        self.selected = selected
        self.selectedAt = selectedAt
    }
}

// MARK: - Domain aggregate

/// 해시태그 선택 관련 도메인 모델.
///
/// 이 모델은 하나의 기록 날짜(`date`)에 대해 선택 가능한 모든 해시태그의 상태를 관리합니다.
///
/// **도메인 규칙**
/// - 최대 3개의 해시태그만 선택할 수 있습니다.
/// - 이미 선택된 해시태그는 언제든 해제할 수 있습니다.
/// - 최대 개수에 도달한 상태에서 미선택 해시태그를 선택하려고 하면 무시됩니다.
struct HashtagRecordModel {
    // MARK: - Domain Constants
        
    /// 선택 가능한 최대 해시태그 수
    private let maxSelectedCount: Int = 3
    
    // MARK: - Domain State
    
    var date: Date
    var checks: [HashtagCheck]
    
    // MARK: - init
    
    init(date: Date, checks: [HashtagCheck]) {
        self.date = date
        self.checks = checks
    }
    
    // MARK: - Domain Derived Properties
    
    var selectedHashtags: [HashtagCategory] {
        checks.filter { $0.selected }.map { $0.hashtag }
    }
    
    var selectedCount: Int { selectedHashtags.count }
    
    var canSelectMore: Bool { selectedCount < maxSelectedCount }
    
    var isFull: Bool { selectedCount == maxSelectedCount }
    
    func check(of hashtagId: HashtagCategory.ID) -> HashtagCheck? {
        checks.first { $0.hashtag.id == hashtagId }
    }
    
    // MARK: - Side Effects (State Mutations)
    
    mutating func toggle(_ hashtagId: HashtagCategory.ID, at time: Date = .now) {
        guard let idx = checks.firstIndex(where: { $0.hashtag.id == hashtagId }) else { return }
        checks[idx].selected.toggle()
        checks[idx].selectedAt = checks[idx].selected ? time : nil
    }
    
    // 업로드 후의 선택 규칙
    mutating func markUploaded(_ hashtagId: HashtagCategory.ID, at time: Date = .now) {
        guard let idx = checks.firstIndex(where: { $0.hashtag.id == hashtagId }) else { return }
        
        if checks[idx].selected {
            // 이미 선택된 것은 언제든 해제 가능
            checks[idx].selected = false
            checks[idx].selectedAt = nil
        } else if canSelectMore {
            // 남은 해시태그가 있을 때만 선택
            checks[idx].selected = true
            checks[idx].selectedAt = time
        }
        // 해시태그가 가득 찼고(=canSelectMore == false) 미선택을 누르면 무시
    }
    
    /// 런타임에 해시태그를 추가(뷰에서 신규 해시태그 생성 시)
    mutating func appendHashtagIfNeeded(_ newHashtag: HashtagCategory) {
        guard checks.contains(where: {
            $0.hashtag.id == newHashtag.id }) == false else { return }
        checks.append(.init(hashtag: newHashtag))
    }
}

extension HashtagRecordModel {
    static func initial(
        for date: Date = .now,
        catalog: HashtagCatalogProviding = DefaultHashtagCatalog()
    ) -> Self {
        .init(
            date: date,
            checks: catalog.all.map { .init(hashtag: $0, selected: false) }
        )
    }
}
