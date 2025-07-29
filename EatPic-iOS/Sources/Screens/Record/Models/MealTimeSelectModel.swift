//
//  MealTimeSelectModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import SwiftUI

// MARK: - MealType Enum
enum MealType: String, CaseIterable {
    case breakfast = "아침"
    case lunch = "점심"
    case dinner = "저녁"
    case snack = "간식"
}

// MARK: 식사기록 버튼 상태
enum MealButtonType {
    case completed // 이미 기록 완료한 시간대라면 completed
    case unselected // 기록 완료하지 못한 시간대 + 선택되지 않은 버튼이라면 unselected
}

// MARK: - MealButton 데이터 모델
struct MealButtonData {
    let title: String
    let type: MealButtonType
    let icon: Image?
    let mealType: MealType?
    
    init(
        title: String,
        type: MealButtonType,
        icon: Image? = nil,
        mealType: MealType? = nil
    ) {
        self.title = title
        self.type = type
        self.icon = icon
        self.mealType = mealType
    }
} 
