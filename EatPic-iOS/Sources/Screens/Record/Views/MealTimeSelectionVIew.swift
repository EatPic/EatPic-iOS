//
//  MealTimeSelectionVIew.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

enum MealType: String, CaseIterable {
    case breakfast = "아침"
    case lunch = "점심"
    case dinner = "저녁"
    case snack = "간식"
}

struct MealTimeSelectView: View {
    
    @EnvironmentObject private var container: DIContainer
    
    // 식사 시간 선택 버튼을 위한
    @State private var selectedMeal: MealType?
    
    var body: some View {
        VStack {
            // 캐릭터 이미지
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)
            
            Spacer().frame(height: 36)
            
            HStack {
                // 질문
                Text("이번에 기록할 \n식사는 언제 드신 건가요?")
                    .font(.dsTitle2)
                    .foregroundStyle(.black)
                    .frame(alignment: .leading)
      
                Spacer()
            }
            
            Spacer().frame(height: 32)
            
            // 식사 버튼들
            VStack(spacing: 24) {
                // 첫 번째 행 (아침, 점심)
                HStack(spacing: 21) {
                    MealButton(
                        mealType: .breakfast,
                        isSelected: selectedMeal == .breakfast,
                        action: {
                            if selectedMeal == .breakfast {
                                selectedMeal = nil  // 같은 버튼 클릭 시 해제
                                print("버튼 선택 해제")
                            } else {
                                selectedMeal = .breakfast  // 다른 버튼 선택
                                print("아침 선택")
                            }
                        }
                    )
                    
                    MealButton(
                        mealType: .lunch,
                        isSelected: selectedMeal == .lunch,
                        action: {
                            if selectedMeal == .lunch {
                                selectedMeal = nil  // 같은 버튼 클릭 시 해제
                                print("버튼 선택 해제")
                            } else {
                                selectedMeal = .lunch // 버튼 클릭 시
                                print("점심 선택")
                            }
                        }
                    )
                }
                
                // 두 번째 행 (저녁, 간식)
                HStack(spacing: 21) {
                    MealButton(
                        mealType: .dinner,
                        isSelected: selectedMeal == .dinner,
                        action: {
                            if selectedMeal == .dinner {
                                selectedMeal = nil  // 같은 버튼 클릭 시 해제
                                print("버튼 선택 해제")
                            } else {
                                selectedMeal = .dinner  // 다른 버튼 선택
                                print("저녁 선택")
                            }
                        }
                    )
                    
                    MealButton(
                        mealType: .snack,
                        isSelected: selectedMeal == .snack,
                        action: {
                            if selectedMeal == .snack {
                                selectedMeal = nil  // 같은 버튼 클릭 시 해제
                                print("버튼 선택 해제")
                            } else {
                                selectedMeal = .snack  // 다른 버튼 선택
                                print("간식 선택")
                            }
                        }
                    )
                }
            }
            
            Spacer().frame(height: 102)
            
            // 최하단 버튼 (다음으로 넘어가는 액션)
            PrimaryButton(
                color: selectedMeal != nil ? .green060 : .gray020,
                text: "다음",
                font: .dsTitle3,
                textColor: selectedMeal != nil ? .white : .gray040,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                if let selectedMeal = selectedMeal {
                    // TODO: selectedMeal의 정보 저장?
                    // TODO: HastageSelectionView로 Navigation
                    container.router.push(.hashtagSelectionView)
                    print("다음 화면으로 이동 - 선택된 식사: \(selectedMeal.rawValue)")
                }
            }
            .disabled(selectedMeal == nil) // selectedMeal이 비어있을 경우 버튼 동작 비활성화
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - MealButton
private struct MealButton: View {
    let mealType: MealType
    let isSelected: Bool
    let action: () -> Void
    
    private var title: String {
        switch mealType {
        case .breakfast: return "아침"
        case .lunch: return "점심"
        case .dinner: return "저녁"
        case .snack: return "간식"
        }
    }
    
    private var icon: Image {
        switch mealType {
        case .breakfast: return Image("Record/ic_home_morning")
        case .lunch: return Image("Record/ic_home_lunch")
        case .dinner: return Image("Record/ic_home_dinner")
        case .snack: return Image("Record/ic_home_dessert")
        }
    }
    
    private var backgroundColor: Color {
        return isSelected ? .green010 : .white
    }
    
    private var borderColor: Color {
        return isSelected ? .green060 : .gray050
    }
    
    private var textColor: Color {
        return isSelected ? .green060 : .gray050
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                icon
                    .renderingMode(.template)
                    .foregroundStyle(textColor)
                
                Text(title)
                    .font(.dsHeadline)
                    .foregroundStyle(textColor)
            }
            .padding(.horizontal, 20)
            .frame(width: 170, height: 100)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    MealTimeSelectView()
}
