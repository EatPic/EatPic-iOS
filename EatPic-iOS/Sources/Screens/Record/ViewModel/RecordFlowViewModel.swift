//
//  RecordFlowViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation
import UIKit

// 각 화면별 데이터 취합 모델
struct RecordFlowState {
    var images: [UIImage]
    var mealSlot: MealSlot?
    var hasTags: [HashtagKind]
    var myMemo: String
    var myRecipe: String
    var recipeLink: String?
    var storeLocation: String
    var sharedFeed: Bool
    var createdAt: Date
}

// 팩토리 시그니처도 메인 액터에서만 호출되도록
typealias MealRecordVMFactory = @MainActor (_ date: Date) -> MealRecordViewModel

/// 기록 플로우의 루트 상태를 관리하는 뷰모델.
/// - 책임:
///   - `RecordFlowState`의 저장/갱신(단방향 상태)
///   - 화면 전이 가드(검증)
///   - 서버 DTO 스냅샷 생성
@MainActor
final class RecordFlowViewModel: ObservableObject {

    /// 화면 전 단계가 공유하는 루트 상태
    @Published private(set) var state: RecordFlowState

    // MARK: - Init

    /// 최초 진입 시 루트 상태를 주입합니다.
    /// - Note: 보통 라우팅 진입 시점에서 `createdAt`, `images`를 채운 상태로 들어옵니다.
    init() {
        self.state = .init(
            images: [],
            mealSlot: nil,
            hasTags: [],
            myMemo: "",
            myRecipe: "",
            recipeLink: nil,
            storeLocation: "",
            sharedFeed: false,
            createdAt: Date()
        )
    }

    // MARK: - Derived (화면 전이 가드)

    /// 해시태그 선택 화면으로 넘어갈 수 있는지 여부
    public var canProceedToHashtag: Bool {
        !state.images.isEmpty
    }

    /// 기록(작성) 화면으로 넘어갈 수 있는지 여부
    public var canProceedToRecord: Bool {
        !state.hasTags.isEmpty && !state.images.isEmpty
    }

    /// 업로드 가능 여부(최소 요건 충족)
    public var isReadyToUpload: Bool {
        // 필요시 정책 조정: 메모/레시피/위치 필수 여부 등
        canProceedToRecord
    }

    // MARK: - Mutations (사이드이펙트 없음)

    /// 최초 진입 후 한 번만 세팅하고 싶을 때 사용(이미 값이 있으면 덮어쓰지 않게 보호)
    public func bootstrapIfNeeded(createdAt: Date, images: [UIImage]) {
        if state.images.isEmpty {
            state.createdAt = createdAt
            state.images = images
        }
    }

    public func replaceImages(_ images: [UIImage]) {
        state.images = images
    }

    public func appendImages(_ images: [UIImage]) {
        state.images.append(contentsOf: images)
    }

    public func removeImage(at index: Int) {
        guard state.images.indices.contains(index) else { return }
        state.images.remove(at: index)
    }
    
    public func addMealSlot(_ slot: MealSlot) {
        state.mealSlot = slot
    }

    public func setTags(_ tags: [HashtagKind]) {
        state.hasTags = tags
    }

    public func setMemo(_ memo: String) {
        state.myMemo = memo
    }

    public func setRecipeText(_ text: String) {
        state.myRecipe = text
    }

    public func setRecipeLink(_ urlString: String?) {
        state.recipeLink = (urlString?.isEmpty == true) ? nil : urlString
    }

    public func setStoreLocation(_ location: String) {
        state.storeLocation = location
    }

    public func setSharedFeed(_ isOn: Bool) {
        state.sharedFeed = isOn
    }

    // MARK: - Snapshot / DTO

   // DTO 생성해서 반환하는 함수를 여기다가 만들 예정

    /// 업로드 완료 후 상태를 초기화합니다. (정책에 따라 조정)
    public func resetForNext(createdAt: Date = .now) {
        state.createdAt = createdAt
        state.images = []
        state.hasTags = []
        state.myMemo = ""
        state.myRecipe = ""
        state.recipeLink = nil
        state.storeLocation = ""
        state.sharedFeed = false
    }
}
