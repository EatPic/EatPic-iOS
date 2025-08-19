//
//  RecordFlowViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation
import UIKit

/// 기록 플로우에서 날짜를 기준으로 서브 뷰모델을 생성하기 위한 팩토리 시그니처입니다.
/// - Warning: UI 스레드 제약을 명확히 하기 위해 `@MainActor`로 선언합니다.
typealias MealRecordVMFactory = @MainActor (_ date: Date) -> MealRecordViewModel

/// 기록 플로우의 루트 상태를 관리하는 뷰모델입니다.
/// - Responsibilities:
///   - `RecordFlowState`의 저장/갱신(단방향 상태)
///   - 화면 전이 가드(검증)
/// - Note: UI 업데이트 보장을 위해 `@MainActor`로 동작합니다.
@MainActor
final class RecordFlowViewModel: ObservableObject {

    /// 화면 전 단계가 공유하는 루트 상태
    @Published private(set) var state: RecordFlowState

    // MARK: - Init

    /// 최초 진입 시 루트 상태를 주입합니다.
    /// - Note: 보통 라우팅 진입 시점에서 `createdAt`, `images`를 채운 상태로 들어옵니다.
    init() {
        self.state = .init()
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
        // [25.08.20] 메모/레시피/위치 필수 여부 적용해야 함 - 리버/이재원
        canProceedToRecord
    }

    // MARK: - Mutations (사이드이펙트 없음)

    /// 최초 진입 시 한 번만 초기 상태를 세팅합니다. 이미 값이 있으면 덮어쓰지 않습니다.
    /// - Parameters:
    ///   - createdAt: 기록 기준 시각
    ///   - images: 최초 선택된 이미지 배열
    public func bootstrapIfNeeded(createdAt: Date, images: [UIImage]) {
        if state.images.isEmpty {
            state.createdAt = createdAt
            state.images = images
        }
    }

    /// 현재 보관 중인 이미지를 전달된 배열로 교체합니다.
    public func replaceImages(_ images: [UIImage]) {
        state.images = images
    }

    /// 현재 보관 중인 이미지 배열의 뒤에 새 이미지를 추가합니다.
    public func appendImages(_ images: [UIImage]) {
        state.images.append(contentsOf: images)
    }

    /// 지정한 인덱스의 이미지를 제거합니다. 인덱스가 유효하지 않으면 무시합니다.
    /// - Parameter index: 제거할 위치
    public func removeImage(at index: Int) {
        guard state.images.indices.contains(index) else { return }
        state.images.remove(at: index)
    }
    
    /// 선택한 식사 시간대를 설정합니다.
    /// - Parameter slot: 아침/점심/저녁/간식 식사 슬롯
    public func addMealSlot(_ slot: MealSlot) {
        state.mealSlot = slot
    }

    /// 선택된 해시태그 목록을 설정합니다.
    /// - Parameter tags: 해시태그 카테고리 배열
    public func setTags(_ tags: [HashtagCategory]) {
        state.hasTags = tags
    }

    /// 사용자가 입력한 메모를 설정합니다.
    public func setMemo(_ memo: String) {
        state.myMemo = memo
    }

    /// 레시피/내용 본문을 설정합니다.
    public func setRecipeText(_ text: String) {
        state.myRecipe = text
    }

    /// 레시피 링크(URL 문자열)를 설정합니다. 빈 문자열은 `nil`로 정규화합니다.
    public func setRecipeLink(_ urlString: String?) {
        state.recipeLink = (urlString?.isEmpty == true) ? nil : urlString
    }

    /// 사용자가 지정한 위치 텍스트를 설정합니다.
    public func setStoreLocation(_ location: PicCardStoreLocation) {
        state.storeLocation = location
    }

    /// 피드 공개 여부를 설정합니다.
    public func setSharedFeed(_ isOn: Bool) {
        state.sharedFeed = isOn
    }

    /// 업로드 완료 후 다음 기록을 위해 상태를 초기화합니다.
    /// - Parameter createdAt: 다음 기록의 기준 시각(기본값: 현재 시각)
    public func resetForNext(createdAt: Date = .now) {
        state.createdAt = createdAt
        state.images = []
        state.hasTags = []
        state.myMemo = ""
        state.myRecipe = ""
        state.recipeLink = nil
        state.storeLocation = .init(name: "")
        state.sharedFeed = false
    }
}
