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
    let mealTime: String
    let isRecorded: Bool
    let imageName: String? // optional로 변경
    
    init(mealTime: String, isRecorded: Bool = false, imageName: String? = nil) {
        self.mealTime = mealTime
        self.isRecorded = isRecorded
        self.imageName = imageName
    }
}
