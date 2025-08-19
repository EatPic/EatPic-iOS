//
//  RecordFlowState.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import UIKit

/// 사용자가 기록 플로우에서 입력한 값을 일시적으로 모아두는 **작성 초안(draft) 상태**입니다.
/// - Note: 초기 구현 단계에서 실용성을 위해 `UIImage`를 보관합니다. 인코딩은 UseCase 내부에서 `MainActor.run`으로 수행되어
///   non-Sendable 이슈를 회피합니다. 추후 필요 시 `ImageRef(Data/URL)`로 치환하여 도메인 순수성을 강화할 수 있습니다.
struct RecordFlowState {
    var images: [UIImage]
    var mealSlot: MealSlot?
    var hasTags: [HashtagCategory]
    var myMemo: String
    var myRecipe: String
    var recipeLink: String?
    var storeLocation: PicCardStoreLocation
    var sharedFeed: Bool
    var createdAt: Date
    
    init(
        images: [UIImage] = [],
        mealSlot: MealSlot? = nil,
        hasTags: [HashtagCategory] = [],
        myMemo: String = "",
        myRecipe: String = "",
        recipeLink: String? = nil,
        storeLocation: PicCardStoreLocation = .init(name: ""),
        sharedFeed: Bool = true,
        createdAt: Date = .now
    ) {
        self.images = images
        self.mealSlot = mealSlot
        self.hasTags = hasTags
        self.myMemo = myMemo
        self.myRecipe = myRecipe
        self.recipeLink = recipeLink
        self.storeLocation = storeLocation
        self.sharedFeed = sharedFeed
        self.createdAt = createdAt
    }
}
