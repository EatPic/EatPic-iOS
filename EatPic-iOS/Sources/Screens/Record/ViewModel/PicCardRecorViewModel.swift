//
//  PicCardRecorViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/10/25.
//

import Foundation

struct PicCardRecorModel {
    var mealTime: MealTime?
    var hashtags: [String] = []
    var memo: String = ""
    var recipe: String = ""
    var locationName: String = ""
    var latitude: Double?
    var longitude: Double?
    var isShared: Bool = true
    var recipeURL: String?      // 사용자가 붙여 넣은 문자열 그대로
    var cardImageURL: String?   // 업로드/선택 결과 URL 문자열
}

enum MealTime: String, Codable, CaseIterable {
    case breakfast, lunch, dinner, snack
}

final class PicCardRecorViewModel: ObservableObject {
    @Published var recordModel: PicCardRecorModel = .init()
    
    func updateMealTime(_ mealTime: MealTime) {
        recordModel.mealTime = mealTime
    }
    
    func updateHashtags(_ hashtags: [String]) {
        recordModel.hashtags = hashtags
    }
}
