import Foundation

/// 식사 타입을 나타내는 열거형
enum MealType: String, CaseIterable {
    case breakfast = "아침"
    case lunch = "점심"
    case dinner = "저녁"
    case snack = "간식"
}
