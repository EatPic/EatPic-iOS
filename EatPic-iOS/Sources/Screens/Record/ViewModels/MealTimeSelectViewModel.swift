//
//  MealTimeSelectViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import SwiftUI

/// 식사 시간 선택 화면의 ViewModel
class MealTimeSelectViewModel: ObservableObject {
    
    // MARK: - Property
    
    /// 선택된 식사 시간
    @Published var selectedMeal: MealType?
    
    /// 식사 버튼 데이터
    @Published var mealButtons: [MealButtonData] = [
        // 선택 가능한 식사들
        MealButtonData(
            title: "아침",
            type: .unselected,
            icon: Image("Record/ic_home_lunch"),
            mealType: .breakfast
        ),
        MealButtonData(
            title: "점심",
            type: .unselected,
            icon: Image("Record/ic_home_lunch"),
            mealType: .lunch
        ),
        MealButtonData(
            title: "저녁",
            type: .unselected,
            icon: Image("Record/ic_home_dinner"),
            mealType: .dinner
        ),
        MealButtonData(
            title: "간식",
            type: .unselected,
            icon: Image("Record/ic_home_dessert"),
            mealType: .snack
        )
    ]
    
    /// 식사 시간 선택
    func selectMeal(_ mealType: MealType) {
        selectedMeal = mealType
        print("선택된 식사: \(mealType.rawValue)")
    }
    
    /// 확인 버튼 액션
    func confirmButtonTapped() {
        if let selectedMeal = selectedMeal {
            //
            print("다음으로 넘어가는 기능 구현 - 선택된 식사: \(selectedMeal.rawValue)")
        } else {
            print("식사를 선택해주세요")
        }
    }
    
    /// 완료된 식사 버튼 액션
    func completedMealButtonTapped() {
        print("이미 완료된 식사입니다")
    }
} 
