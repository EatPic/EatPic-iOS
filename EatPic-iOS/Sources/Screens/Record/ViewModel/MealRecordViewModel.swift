//
//  MealRecordViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation

/// 끼니 기록 카드의 상태를 관리하는 ViewModel.
/// - 책임: 도메인 모델(`MealRecordModel`)의 읽기/갱신과 파생 상태 계산.
/// - 비고: 권한/촬영/업로드 등 부작용은 UseCase에서 처리한 뒤,
///         최종적으로 `markRecorded(slot:at:)`을 호출하여 상태만 갱신합니다.
@MainActor
final class MealRecordViewModel: ObservableObject {

    /// 현재 화면에 표시할 도메인 모델
    @Published private(set) var model: MealRecordModel

    // MARK: - Init
    init(model: MealRecordModel = .initial()) {
        self.model = model
    }

    // MARK: - Driven States
    var date: Date { model.date }
    var uploadedCount: Int { model.uploadedCount }
    var hasSelectable: Bool { model.hasSelectable }
    var selectedSlot: MealSlot? { model.selectedSlot }
    
    // MARK: - 조회
    
    func isUploaded(_ slot: MealSlot) -> Bool {
        model.check(of: slot)?.uploaded == true
    }
    func isSelected(_ slot: MealSlot) -> Bool {
        model.check(of: slot)?.selected == true
    }
    func uploadedAt(_ slot: MealSlot) -> Date? {
        model.check(of: slot)?.uploadedAt
    }
    func selectedAt(_ slot: MealSlot) -> Date? {
        model.check(of: slot)?.selectedAt
    }

    // MARK: - Domain Mutations (Side-effect free)
    
    func select(_ slot: MealSlot) {
        model.select(slot, at: .now)
    }

    /// 도메인 모델에 위임하여 슬롯을 기록 상태로 전환합니다.
    /// - Parameters:
    ///   - slot: 기록할 끼니 슬롯
    ///   - time: 기록 시각(일반적으로 `.now`)
    func markUploaded(slot: MealSlot, at time: Date = .now) {
        model.markUploaded(slot, at: time)
    }
    
    func deleteUploaded(_ slot: MealSlot) {
        model.deleteUploaded(slot, at: .now)
    }

    /// 오늘 날짜로 초기화
    func reset(for date: Date = .now) {
        model = .initial(for: date)
    }
}
