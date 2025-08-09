//
//  MealTimeSelectionVIew.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

/// 식사 시간을 선택하는 화면
/// 아침, 점심, 저녁, 간식 중 하나를 선택할 수 있음
struct MealTimeSelectView: View {
    
    /// 의존성 주입 컨테이너 (네비게이션 라우터 등 포함)
    @EnvironmentObject private var container: DIContainer
    
    // MARK: - State Properties
    
    /// 사용자가 선택한 식사 타입 (Optional로 초기에는 아무것도 선택되지 않음)
    @State private var selectedMeal: MealType?

    // MARK: - Body
    
    var body: some View {
        VStack {
            // MARK: - 상단 캐릭터 이미지
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)
            
            Spacer().frame(height: 36)
            
            // MARK: - 메인 질문 텍스트
            HStack {
                Text("이번에 기록할 \n식사는 언제 드신 건가요?")
                    .font(.dsTitle2)
                    .foregroundStyle(.black)
                    .frame(alignment: .leading)
      
                Spacer() // 왼쪽 정렬을 위한 Spacer
            }
            
            Spacer().frame(height: 32)
            
            // MARK: - 식사 시간 선택 버튼들
            VStack(spacing: 24) {
                // 첫 번째 행: 아침, 점심
                HStack(spacing: 21) {
                    MealButton(
                        mealType: .breakfast,
                        isSelected: selectedMeal == .breakfast,
                        action: {
                            toggleMealSelection(.breakfast)
                        }
                    )
                    
                    MealButton(
                        mealType: .lunch,
                        isSelected: selectedMeal == .lunch,
                        action: {
                            toggleMealSelection(.lunch)
                        }
                    )
                }
                
                // 두 번째 행: 저녁, 간식
                HStack(spacing: 21) {
                    MealButton(
                        mealType: .dinner,
                        isSelected: selectedMeal == .dinner,
                        action: {
                            toggleMealSelection(.dinner)
                        }
                    )
                    
                    MealButton(
                        mealType: .snack,
                        isSelected: selectedMeal == .snack,
                        action: {
                            toggleMealSelection(.snack)
                        }
                    )
                }
            }
            
            Spacer().frame(height: 102) // 원본과 동일한 간격
            
            // MARK: - 하단 다음 버튼 (PrimaryButton 사용)
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
                    // TODO: [25.07.30] selectedMeal의 정보 저장 - 비엔/이은정
                    container.router.push(.hashtagSelection(selectedMeal: selectedMeal))
                    print("다음 화면으로 이동 - 선택된 식사: \(selectedMeal.rawValue)")
                }
            }
            .disabled(selectedMeal == nil) // 선택된 식사가 없으면 비활성화
        }
        .padding(.horizontal, 16) // 좌우 여백
        // MARK: - 네비게이션 바 설정
        .customNavigationBar {
            Text("Pic 카드 기록")
        } right: {
            // 홈으로 이동하는 닫기 버튼
            Button(action: {
                container.router.popToRoot()
            }, label: {
                Image("Record/btn_home_close")
            })
        }
    }
    
    // MARK: - Computed Properties
    // PrimaryButton을 사용하므로 별도의 computed properties 불필요
    
    // MARK: - Private Methods
    
    /// 식사 타입 선택/해제를 토글하는 메서드
    /// - Parameter mealType: 토글할 식사 타입
    private func toggleMealSelection(_ mealType: MealType) {
        if selectedMeal == mealType {
            // 같은 버튼을 다시 클릭한 경우 → 선택 해제
            selectedMeal = nil
            print("식사 선택 해제")
        } else {
            // 다른 버튼을 클릭한 경우 → 새로운 식사 선택
            selectedMeal = mealType
            print("\(mealType.rawValue) 선택")
        }
    }
}

// MARK: - MealButton Component

/// 개별 식사 타입을 선택하는 버튼 컴포넌트
/// 아이콘과 텍스트를 세로로 배치한 카드형 버튼
struct MealButton: View {
    /// 식사 타입 (아침, 점심, 저녁, 간식)
    let mealType: MealType
    
    /// 현재 선택된 상태인지 여부
    let isSelected: Bool
    
    /// 버튼이 탭되었을 때 실행할 액션
    let action: () -> Void
    
    /// 식사 타입별 타이틀 텍스트
    private var title: String {
        switch mealType {
        case .breakfast: return "아침"
        case .lunch: return "점심"
        case .dinner: return "저녁"
        case .snack: return "간식"
        }
    }
    
    /// 식사 타입별 아이콘 이미지
    private var icon: Image {
        switch mealType {
        case .breakfast: return Image("Record/ic_home_morning")
        case .lunch: return Image("Record/ic_home_lunch")
        case .dinner: return Image("Record/ic_home_dinner")
        case .snack: return Image("Record/ic_home_dessert")
        }
    }
    
    /// 선택 상태에 따른 배경색
    private var backgroundColor: Color {
        return isSelected ? .green010 : .white
    }
    
    /// 선택 상태에 따른 테두리 색상
    private var borderColor: Color {
        return isSelected ? .green060 : .gray050
    }
    
    /// 선택 상태에 따른 텍스트/아이콘 색상
    private var textColor: Color {
        return isSelected ? .green060 : .gray050
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                // MARK: - 식사 타입별 아이콘
                icon
                    .renderingMode(.template)
                    .foregroundStyle(textColor)
                
                // MARK: - 식사 타입 텍스트
                Text(title)
                    .font(.dsHeadline)
                    .foregroundStyle(textColor)
            }
            .padding(.horizontal, 20)
            .frame(width: 170, height: 100) // 원본 크기
            .background(backgroundColor) // 선택 시 연한 그린, 기본 흰색
            .clipShape(RoundedRectangle(cornerRadius: 10)) // 원본 모서리
            .overlay(alignment: .center) {
                // 테두리: 선택 시 그린, 기본 회색
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            }
        }
    }
}

// #Preview {
//    MealTimeSelectView()
// }
