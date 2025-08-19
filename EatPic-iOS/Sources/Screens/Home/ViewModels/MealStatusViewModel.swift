//
//  MealStatusViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import Moya

@Observable
class MealStatusViewModel {
    private let cardProvider: MoyaProvider<CardTargetType>
    
    var mealStatus: [MealStatusModel] =
    MealSlot.allCases.map { MealStatusModel(mealSlot: $0) }
    
    init(container: DIContainer) {
        self.cardProvider = container.apiProviderStore.card()
    }
    
    func deleteMealRecord(meal: MealStatusModel) {
        if let idx = mealStatus.firstIndex(where: { $0.id == meal.id }) {
            mealStatus[idx] = MealStatusModel(
                mealSlot: meal.mealSlot,
                isRecorded: false
            )
            // TODO: [25. 08.06] 실제 이미지 데이터 삭제 로직 추가
            // - 로컬 파일 삭제
            // - 데이터베이스에서 삭제
        }
    }
    
    // MARK: - API Methods
    
    @MainActor
    func fetchMealStatus() async {
        do {
            let response = try await
            cardProvider.requestAsync(.todayMeals)
            let dto = try JSONDecoder().decode(
                TodayMealsResponse.self,
                from: response.data)
            
            /// 서버에서 받은 배열 딕셔너리 형태로 저장
            let byMeal = Dictionary(
                uniqueKeysWithValues: dto.result.map { ($0.meal, $0)
                })
            
            /// 기존 모델에 매핑
            mealStatus = MealSlot.allCases.map { slot in
                if let item = byMeal[slot] {
                    return MealStatusModel(
                        mealSlot: slot,
                        isRecorded: true,
                        imageName: item.cardImageUrl
                    )
                } else {
                    return MealStatusModel(mealSlot: slot, isRecorded: false)
                }
            }
            
            print(mealStatus)
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
}
