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

    // 중복삭제 방지
    private var isDeleting: Bool = false

    init(container: DIContainer) {
        self.cardProvider = container.apiProviderStore.card()
    }

    // MARK: - API: 오늘 식사현황
    @MainActor
    func fetchMealStatus() async {
        do {
            let response = try await cardProvider.requestAsync(.todayMeals)
            let dto = try JSONDecoder().decode(TodayMealsResponse.self, from: response.data)

            // meal을 key로
            let byMeal = Dictionary(uniqueKeysWithValues: dto.result.map { ($0.meal, $0) })

            // 서버 값 → 모델 매핑 (cardId 포함!)
            mealStatus = MealSlot.allCases.map { slot in
                if let item = byMeal[slot] {
                    return MealStatusModel(
                        mealSlot: slot,
                        isRecorded: true,
                        imageName: item.cardImageUrl,
                        cardId: item.cardId
                    )
                } else {
                    return MealStatusModel(mealSlot: slot, isRecorded: false)
                }
            }
            print("오늘의 식사 현황 API 호출 성공🟢")
            print(mealStatus)
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }

    // MARK: - API: 카드 삭제
    /// 실제 서버에 DELETE 호출
    @MainActor
    private func requestDeleteCard(cardId: Int) async throws {
        let response = try await cardProvider.requestAsync(.deleteCard(cardId: cardId))
        _ = try JSONDecoder().decode(APIResponse<CardDeleteResult>.self, from: response.data)
    }

    /// 외부에서 호출: 삭제 버튼 눌렀을 때
    @MainActor
    func confirmMealDeletion(meal: MealStatusModel) async {
        guard !isDeleting else { return }
        guard let cardId = meal.cardId else {
            print("삭제 불가: cardId 없음")
            return
        }

        isDeleting = true
        defer { isDeleting = false }

        do {
            // 1) 서버 삭제
            try await requestDeleteCard(cardId: cardId)

            // 2) UI 반영(해당 슬롯 비우기)
            if let idx = mealStatus.firstIndex(where: { $0.id == meal.id }) {
                mealStatus[idx] = MealStatusModel(
                    mealSlot: meal.mealSlot,
                    isRecorded: false,
                    imageName: nil,
                    cardId: nil
                )
            }

            print("삭제 성공: cardId \(cardId)")

        } catch {
            print("삭제 실패:", error.localizedDescription)
        }
    }
}
