//
//  MealStatusViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

class MealStatusViewModel: ObservableObject {
    
    @Published var mealStatus: [MealStatusModel] = [
        MealStatusModel(mealTime: "아침", isRecorded: true, imageName: "Home/exampleSalad"),
        MealStatusModel(mealTime: "점심", isRecorded: true, imageName: "Home/exampleSalad"),
        MealStatusModel(mealTime: "저녁", isRecorded: false), // imageName 없음
        MealStatusModel(mealTime: "간식", isRecorded: false)  
    ]
    
    // 수정 버튼 액션
    func editButtonTapped() {
        print("이거 어케함요? 아래 버튼 뜨게 해야함")
//        Button(role: .destructive, action: {
//            print("신고하기")
//        }) {
//            Label("신고하기", systemImage: "exclamationmark.bubble")
//        }
    }
    
    
}
