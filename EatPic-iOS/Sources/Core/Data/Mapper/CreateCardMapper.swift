//
//  CreateCardMapper.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation

/// 기록 상태를 서버 전송 DTO로 변환하는 매퍼입니다.
/// - Important: **매핑 일원화**를 위해 변환 로직을 이곳에만 둡니다.
enum CreateCardMapper {
    /// `RecordFlowState`를 서버 전송용 `CreateCardRequest`로 변환합니다.
    /// - Parameter state: 화면에서 수집한 기록 상태
    /// - Throws: `APIError.noData` — 필수 값(예: `mealSlot`)이 누락된 경우
    /// - Returns: 전송 가능한 `CreateCardRequest`
    static func makeRequest(from state: RecordFlowState) throws -> CreateCardRequest {
        let tags = state.hasTags.map(\.title)
        guard let meal = state.mealSlot else { throw APIError.noData }
        return .init(
            latitude: state.storeLocation.latitude ?? 0,
            longitude: state.storeLocation.longitude ?? 0,
            recipe: state.myRecipe,
            recipeUrl: state.recipeLink ?? "",
            memo: state.myMemo,
            isShared: state.sharedFeed,
            locationText: state.storeLocation.name,
            meal: meal,
            hashtags: tags
        )
    }
}
