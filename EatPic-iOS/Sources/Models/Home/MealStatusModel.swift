//
//  MealStatusModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

// 홈 뷰의 오늘의 식사현황 모델
struct MealStatusModel: Identifiable {
    let id: String = UUID().uuidString
    let mealSlot: MealSlot
    let isRecorded: Bool
    let imageName: String?
    let cardId: Int?   // ⬅️ 추가: 서버 삭제에 필요

    init(
        mealSlot: MealSlot,
        isRecorded: Bool = false,
        imageName: String? = nil,
        cardId: Int? = nil   // ⬅️ 추가
    ) {
        self.mealSlot = mealSlot
        self.isRecorded = isRecorded
        self.imageName = imageName
        self.cardId = cardId
    }

    var displayName: String {
        switch mealSlot {
        case .BREAKFAST: "아침"
        case .LUNCH: "점심"
        case .DINNER: "저녁"
        case .SNACK: "간식"
        }
    }
}
