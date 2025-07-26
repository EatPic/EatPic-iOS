//
//  mealTimeSelect.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/25/25.
//
import SwiftUI

struct MealTimeSelectView: View {
    // 초기 상태
    @State private var selectedMeal: MealType? // = nil
    
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
            
            // 아침, 점심, 저녁, 간식 버튼 4개
            VStack(spacing: 24) {
                HStack(spacing: 21) {
                    MealButton(
                        title: "아침 기록 완료",
                        type: .completed,
                        mealbtnAction: {print("이거 옵셔널 처리해서 없애보려고 했는데 이상해져서 말음..")}
                        )
                    
                    MealButton(
                        title: "점심 기록 완료",
                        type: .completed,
                        mealbtnAction: {print("이거 옵셔널 처리해서 없애보려고 했는데 이상해져서 말음..")}
                    )
                }
                
                HStack(spacing: 21) {
                    MealButton(
                        title: "저녁",
                        type: .unselected,
                        icon: Image("Record/ic_home_dinner"),
                        isSelected: selectedMeal == .dinner // 현재는 false
                                                            // nil == .dinner → false
                    ) { // trailing closure라고, action : {} 대신 편의 문법
                        selectedMeal = .dinner  // 기록 시간 버튼 클릭 시 실행되는 부분!
                                                // 클릭 시 selectedMeal = .dinner로 상태가 변경
                                                // → 뷰 재렌더링
                                                // → isSelected: selectedMeal == .dinner -> true
                                                // →→ 즉, isSelected가 true 가 됨
                    }
                    
                    MealButton(
                        title: "간식",
                        type: .unselected,
                        icon: Image("Record/ic_home_dessert"),
                        isSelected: selectedMeal == .snack
                    ) {
                        selectedMeal = .snack
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
                print("다음으로 넘어가는 기능 구현")
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - MealType Enum
enum MealType: String, CaseIterable {
    case breakfast = "아침"
    case lunch = "점심"
    case dinner = "저녁"
    case snack = "간식"
}

// MARK: 식사기록 버튼 상태
enum MealButtonType {
    case completed // 이미 기록 완료한 시간대라면 completed
    case unselected // 기록 완료하지 못한 시간대 + 선택되지 않은 버튼이라면 unselected
}

// MARK: - MealButton
private struct MealButton: View {
    
    private var backgroundColor: Color {
        switch type {
        case .completed: return .gray020
        case .unselected: return isSelected ? .green010 : .white
        }
    }
    
    private var borderColor: Color {
        switch type {
        case .completed: return .clear
        case .unselected: return isSelected ? .green060 : .gray050
        }
    }
    
    let title: String
    let type: MealButtonType
    let icon: Image? // ← 이건 Optional Image (nil일 수도 있음)
                     // .completed인 경우 icon이 필요없으므로 optional
    let isSelected: Bool
    var mealbtnAction: () -> Void // ← 이게 action 클로저
    
    init(
        title: String,
        type: MealButtonType,
        icon: Image? = nil,
        isSelected: Bool = false,
        mealbtnAction: @escaping () -> Void
    ) {
        self.title = title
        self.type = type
        self.icon = icon
        self.isSelected = isSelected
        self.mealbtnAction = mealbtnAction
    }
    
    var body: some View {
        Button(action: { // ← 여기서 action이 실행됨!
            if type != .completed { // completed 상태가 아닐 때만 액션 클로저 실행됨
                mealbtnAction() // ← 전달받은 action 클로저 실행
            }
        }, label: {
            VStack {
                switch type {
                case .completed:
                    // 완료된 버튼 (체크마크 + 텍스트)
                    VStack {
                        Image("Record/ic_home_check")
                        
                        Spacer().frame(height: 8)
                        
                        Text(title)
                            .font(.dsHeadline)
                            .foregroundColor(.gray060)
                    }
                    .padding(.horizontal, 20)
                    
                case .unselected:
                    // 선택되지 않은 버튼 (아이콘 + 텍스트)
                    VStack {
                        if let icon = icon { // icon이 nil이 아닐 때만 { } 안의 코드가 실행됨
                                             // (즉 여기서는 icon이 icon 일때 (Optional Binding)
                            icon // ← 여기서는 non-optional Image (nil이 아님)
                                .renderingMode(.template) // Image asset을 색상 변경 가능한 모드로 만듦
                                .foregroundStyle(isSelected ? Color.green060 : Color.gray050)
                        }
                        
                        Text(title)
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
        .disabled(type == .completed) // completed면 클릭 자체가 무시됨
    }
}

#Preview {
    MealTimeSelectView()
}
