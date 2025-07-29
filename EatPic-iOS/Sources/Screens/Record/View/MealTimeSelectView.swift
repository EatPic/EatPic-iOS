//
//  mealTimeSelect.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/25/25.
//
import SwiftUI

struct MealTimeSelectView: View {
    // MARK: - Property
    @StateObject private var viewModel = MealTimeSelectViewModel()
    
    var body: some View {
        VStack {
            // 캐릭터 이미지
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)
            
            Spacer().frame(height: 36)
            
            // 질문
            Text("이번에 기록할 \n식사는 언제 드신 건가요?")
                .font(.dsTitle2)
                .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
            
            Spacer().frame(height: 32)
            
            // 식사 버튼들
            VStack(spacing: 24) {
                HStack(spacing: 21) {
                    ForEach(0..<2, id: \.self) { index in
                        MealButton(
                            data: viewModel.mealButtons[index],
                            isSelected: false,
                            action: {
                                viewModel.completedMealButtonTapped()
                            }
                        )
                    }
                }
                
                HStack(spacing: 21) {
                    ForEach(2..<4, id: \.self) { index in
                        let buttonData = viewModel.mealButtons[index]
                        MealButton(
                            data: buttonData,
                            isSelected: viewModel.selectedMeal == buttonData.mealType,
                            action: {
                                if let mealType = buttonData.mealType {
                                    viewModel.selectMeal(mealType)
                                }
                            }
                        )
                    }
                }
            }
            
            Spacer().frame(height: 102)
            
            // 최하단 버튼 (다음으로 넘어가는 액션)
            PrimaryButton(
                color: .green060,
                text: "확인",
                font: .dsTitle3,
                textColor: .white,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                viewModel.confirmButtonTapped()
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - MealButton
private struct MealButton: View {
    let data: MealButtonData
    let isSelected: Bool
    let action: () -> Void
    
    private var backgroundColor: Color {
        switch data.type {
        case .completed: return .gray020
        case .unselected: return isSelected ? .green010 : .white
        }
    }
    
    private var borderColor: Color {
        switch data.type {
        case .completed: return .clear
        case .unselected: return isSelected ? .green060 : .gray050
        }
    }
    
    var body: some View {
        Button(action: {
            if data.type != .completed {
                action()
            }
        }, label: {
            VStack {
                switch data.type {
                case .completed:
                    // 완료된 버튼 (체크마크 + 텍스트)
                    VStack {
                        Image("Record/ic_home_check")
                        
                        Spacer().frame(height: 8)
                        
                        Text(data.title)
                            .font(.dsHeadline)
                            .foregroundColor(.gray060)
                    }
                    .padding(.horizontal, 20)
                    
                case .unselected:
                    // 선택되지 않은 버튼 (아이콘 + 텍스트)
                    VStack {
                        if let icon = data.icon {
                            icon
                                .renderingMode(.template)
                                .foregroundStyle(isSelected ? Color.green060 : Color.gray050)
                        }
                        
                        Text(data.title)
                            .font(.dsHeadline)
                            .foregroundStyle(isSelected ? Color.green060 : Color.gray050)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .frame(width: 170, height: 100)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
        })
        .disabled(data.type == .completed)
    }
}

#Preview {
    MealTimeSelectView()
}
