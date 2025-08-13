//
//  MealStatusViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

@Observable
class MealStatusViewModel {
    
    /// 식사 현황 목록
    var mealStatus: [MealItem] = []
    
    /// 식사 아이템
    struct MealItem: Identifiable, Codable {
        let id = UUID()
        let cardId: Int
        let cardImageUrl: String
        let meal: String
        
        /// 식사 시간
        var mealTime: String {
            switch meal {
            case "BREAKFAST": return "아침"
            case "LUNCH": return "점심"
            case "DINNER": return "저녁"
            case "SNACK": return "간식"
            default: return meal
            }
        }
        
        /// 기록 여부 (이미지가 있으면 기록된 것)
        var isRecorded: Bool {
            return !cardImageUrl.isEmpty
        }
        
        /// 이미지 이름 (
        var imageName: String? {
            return isRecorded ? cardImageUrl : nil
        }
    }
    
    init() {
        setupSampleData()
    }
    
    
    private func setupSampleData() {
        mealStatus = [
            MealItem(cardId: 1, cardImageUrl: "Home/exampleSalad", meal: "BREAKFAST"),
            MealItem(cardId: 2, cardImageUrl: "Home/exampleSalad", meal: "LUNCH"),
            MealItem(cardId: 3, cardImageUrl: "", meal: "DINNER"),
            MealItem(cardId: 4, cardImageUrl: "", meal: "SNACK")
        ]
    }
    
    /// 식사 기록 삭제
    func deleteMealRecord(meal: MealItem) {
        if let idx = mealStatus.firstIndex(where: { $0.id == meal.id }) {
            // 이미지 URL을 빈 문자열로 설정하여 기록되지 않은 상태로 변경
            mealStatus[idx] = MealItem(cardId: meal.cardId, cardImageUrl: "", meal: meal.meal)
        }
    }
}
