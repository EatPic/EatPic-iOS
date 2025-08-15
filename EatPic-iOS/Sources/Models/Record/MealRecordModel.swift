//
//  MealRecordModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/12/25.
//

import Foundation
import UIKit

/// 업로드 API에 보낼 최소 스냅샷 DTO(임시)
struct RecordCreateDTO: Encodable {
    public let createdAt: Date
    public let tagNames: [String]
    public let memo: String
    public let recipeText: String
    public let recipeLink: String?
    public let storeLocation: String
    public let sharedFeed: Bool
    public let imageCount: Int  // 실제 파일 업로드는 별도 파이프라인에서 처리
}

public enum MealSlot: String, CaseIterable, Codable, Sendable, Equatable {
    case BREAKFAST, LUNCH, DINNER, SNACK
}

/// 개별 끼니의 상태
/// - uploaded: 업로드 완료(체크 고정, 선택 불가)
/// - selected: 업로드 전 사용자가 현재 선택한 끼니(단일 선택)
struct MealCheck {
    let id: MealSlot
    var uploaded: Bool
    var uploadedAt: Date?
    var selected: Bool
    var selectedAt: Date?
    
    init(
        id: MealSlot,
        uploaded: Bool = false,
        uploadedAt: Date? = nil,
        selected: Bool = false,
        selectedAt: Date? = nil
    ) {
        self.id = id
        self.uploaded = uploaded
        self.uploadedAt = uploadedAt
        self.selected = selected
        self.selectedAt = selectedAt
    }
}

struct MealRecordModel {
    var date: Date
    var checks: [MealCheck]   // 항상 4개(아/점/저/간)

    init(date: Date, checks: [MealCheck]) {
        self.date = date
        self.checks = checks
        enforceSelectionInvariant()
    }

    // 업로드 완료된 끼니 수(체크 수 고정)
    var uploadedCount: Int { checks.filter { $0.uploaded }.count }
    
    /// 아직 업로드 안 된(선택 가능) 끼니들
    var selectableSlots: [MealSlot] {
        checks.filter { !$0.uploaded }.map(\.id)
    }
    
    /// 현재 선택된 끼니(업로드 전 단일 선택)
    var selectedSlot: MealSlot? { checks.first(where: { $0.selected })?.id }
    
    // 업로드 안 된 끼니가 존재하는가
    var hasSelectable: Bool { checks.contains { !$0.uploaded }}
    
    // MARK: - 조회

    func check(of slot: MealSlot) -> MealCheck? {
        checks.first { $0.id == slot }
    }
    
    // MARK: - 도메인 규칙
    // 단일 선택 + 업로드 잠금 불변식 유지
    
    /// 사용자가 끼니를 선택.
    /// - 업로드된 끼니는 선택 불가(무시)
    /// - 업로드 전 끼니는 **해당 끼니만 선택**되도록 나머지 선택 해제
    mutating func select(_ slot: MealSlot, at time: Date = .now) {
        guard let mealCheckIdx = checks.firstIndex(where: { $0.id == slot }) else { return }
        guard checks[mealCheckIdx].uploaded == false else { return } // 잠금 중이면 무시
        
        for checkIdx in checks.indices {
            if checkIdx == mealCheckIdx {
                checks[checkIdx].selected = true
                checks[checkIdx].selectedAt = time
            } else if checks[checkIdx].uploaded == false {
                checks[checkIdx].selected = false
                checks[checkIdx].selectedAt = nil
            }
        }
    }

    /// 업로드 성공 처리.
    /// - 선택 여부와 관계없이 해당 슬랏을 업로드 완료로 잠그고, 선택 해제
    /// - 남은 미업로드 끼니 중 **정확히 하나**가 선택되도록 보정
    mutating func markUploaded(_ slot: MealSlot, at time: Date = .now) {
        guard let idx = checks.firstIndex(
            where: { $0.id == slot }) else { return }
        
        checks[idx].uploaded = true
        checks[idx].uploadedAt = time
        checks[idx].selected = false
        checks[idx].selectedAt = nil
        
         enforceSelectionInvariant()
    }
    
    /// 업로드 삭제(사용자 의도적 취소).
    /// - 해당 끼니를 미업로드 상태로 되돌리고, 단일 선택 불변식을 재적용
    mutating func deleteUploaded(_ slot: MealSlot, at time: Date = .now) {
        guard let idx = checks.firstIndex(
            where: { $0.id == slot }) else { return }
        checks[idx].uploaded = false
        checks[idx].uploadedAt = nil
        
        // 일단 기존 선택 유지, 선택이 없는 경우 해당 슬롯을 선택
        if selectedSlot == nil {
            checks[idx].selected = true
            checks[idx].selectedAt = time
        }
    }
    
    /// 불변식: **정확히 하나만 선택**되어야 함.
    /// 가장 최근 선택(at) 1개만 남기고 나머지 해제
    private mutating func enforceSelectionInvariant() {
        let selectableIdxs = checks.indices.filter {
            checks[$0].uploaded == false
        }
        // 선택 가능 항목이 없으면 전체 선택 해제
        guard selectableIdxs.isEmpty == false else {
            for idx in checks.indices {
                checks[idx].selected = false
                checks[idx].selectedAt = nil
            }
            return
        }
        
        let selectedIdxs = selectableIdxs.filter { checks[$0].selected }
        // 최근 선택 1개만 유지
        let sorted = selectedIdxs.sorted {
            let selected1 = checks[$0].selectedAt ?? .distantFuture
            let selected2 = checks[$1].selectedAt ?? .distantPast
            
            return selected1 > selected2
        }
        
        guard let keeper = sorted.first else { return }
        for idx in sorted.dropFirst() {
            checks[idx].selected = false
            checks[idx].selectedAt = nil
        }
        checks[keeper].selected = true
    }
}

extension MealRecordModel {
    static func initial(for date: Date = .now) -> Self {
        .init(
            date: date,
            checks: MealSlot.allCases.map { MealCheck(id: $0) }
        )
    }
}
