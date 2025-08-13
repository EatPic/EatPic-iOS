//
//  MealRecordView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import SwiftUI

struct MealRecordView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var recordFlowViewModel: RecordFlowViewModel
    @StateObject private var viewModel: MealRecordViewModel
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(
        date: Date = .now,
        factory: @escaping MealRecordVMFactory = {
            MealRecordViewModel(model: .initial(for: $0))
        }
    ) {
        _viewModel = .init(wrappedValue: factory(date))
    }

    var body: some View {
        VStack {
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)
            
            Spacer().frame(height: 36)
            
            HStack {
                Text("이번에 기록할 \n식사는 언제 드신 건가요?")
                    .font(.dsTitle2)
                    .foregroundStyle(.black)
                Spacer()
            }
            
            Spacer().frame(height: 32)
            
            // 식사 시간 선택 버튼들
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(MealSlot.allCases, id: \.self) { slot in
                    MealButton(
                        mealType: slot,
                        isSelected: viewModel.isSelected(slot)
                    ) {
                        viewModel.select(slot)
                    }
                }
            }
            
            Spacer().frame(height: 102)
            
            // 하단 다음 버튼
            PrimaryButton(
                color: viewModel.selectedSlot == nil ? .gray020 : .green060,
                text: "다음",
                font: .dsTitle3,
                textColor: viewModel.selectedSlot == nil ? .gray040 : .white,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                guard let selectedSlot = viewModel.selectedSlot else { return }
                recordFlowViewModel.addMealSlot(selectedSlot)
                container.router.push(.hashtagSelection)
            }
        }
        .padding(.horizontal, 16)
        .customNavigationBar {
            Text("Pic 카드 기록")
        } right: {
            Button(action: {
                container.router.popToRoot()
            }, label: {
                Image("Record/btn_home_close")
            })
        }
    }
}

// MARK: - 식사 시간 버튼 (아침 ~간식)
private struct MealButton: View {
    let mealType: MealSlot // 아침, 점심, 저녁, 간식
    let isSelected: Bool // 현재 선택 상태
    let action: () -> Void // 클릭 시 실행할 동작

    // 버튼에 표시할 텍스트
    private var title: String {
        switch mealType {
        case .breakfast: "아침"
        case .lunch:     "점심"
        case .dinner:    "저녁"
        case .snack:     "간식"
        }
    }

    // 버튼에 표시할 아이콘
    private var icon: Image {
        switch mealType {
        case .breakfast: Image("Record/ic_home_morning")
        case .lunch:     Image("Record/ic_home_lunch")
        case .dinner:    Image("Record/ic_home_dinner")
        case .snack:     Image("Record/ic_home_dessert")
        }
    }

    // 선택 상태에 따른 버튼 관련 색상 값
    private var backgroundColor: Color { isSelected ? .green010 : .white }
    private var borderColor: Color { isSelected ? .green060 : .gray050 }
    private var textColor: Color { isSelected ? .green060 : .gray050 }

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
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MealRecordView()
        .environmentObject(RecordFlowViewModel())
}
