//
//  HashtagRecordModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation

enum HashtagKind: String, CaseIterable, Sendable, Equatable {
    case midnightSnack = "야식"
    case brunch = "브런치"
    case eatingAlone = "혼밥"
    case homeMeal = "집밥"
    case dietControl = "식단관리"
    case selfCooking = "자취생"
    case health = "건강"
    case gourmet = "맛집"
    case vegan = "비건"
    case korean = "한식"
    case western = "양식"
    case chinese = "중식"
    case japanese = "일식"
}

/// 해시태그 선택 상태를 나타내는 개별 단위 모델.
///
/// - Parameters:
///   - id: 해시태그 종류(`HashtagKind`)
///   - selected: 현재 선택 여부
///   - selectedAt: 선택 시각 (선택 해제 시 `nil`)
struct HashtagCheck {
    let id: HashtagKind
    var selected: Bool
    var selectedAt: Date?
    
    init(id: HashtagKind, selected: Bool = false, selectedAt: Date? = nil) {
        self.id = id
        self.selected = selected
        self.selectedAt = selectedAt
    }
}

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
    
    var selectedHashtags: [HashtagKind] {
        checks.filter { $0.selected }.map { $0.id }
    }
    
    var selectedCount: Int { selectedHashtags.count }
    
    var canSelectMore: Bool { selectedCount < maxSelectedCount }
    
    var isFull: Bool { selectedCount == maxSelectedCount }
    
    func check(of hashtag: HashtagKind) -> HashtagCheck? {
        checks.first { $0.id == hashtag }
    }
    
    // MARK: - Side Effects (State Mutations)
    
    mutating func togle(_ hashtag: HashtagKind, at time: Date = .now) {
        guard let idx = checks.firstIndex(where: { $0.id == hashtag}) else { return }
        checks[idx].selected.toggle()
        checks[idx].selectedAt = checks[idx].selected ? time : nil
    }
    
    mutating func markUploaded(_ hashtag: HashtagKind, at time: Date = .now) {
        guard let idx = checks.firstIndex(where: { $0.id == hashtag }) else { return }
        
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
}

extension HashtagRecordModel {
    static func initial(for date: Date = .now) -> Self {
        .init(
            date: date,
            checks: HashtagKind.allCases.map { .init(id: $0, selected: false) }
        )
    }
}
