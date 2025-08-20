//
//  MealStatusView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/22/25.
//

import SwiftUI

// MARK: - 메인 뷰
struct MealStatusView: View {
    @State private var viewModel: MealStatusViewModel
    @State private var isEditMode = false
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    var body: some View {
        VStack {
            topBarView

            Spacer().frame(height: 24)

            // 식사 항목 리스트
            HStack(spacing: 6) {
                ForEach(viewModel.mealStatus) { meal in
                    MealItemView(
                        mymeal: meal,
                        isEditMode: isEditMode,
                        onDelete: {
                            Task {
                                await viewModel.confirmMealDeletion(meal: meal)
                            }
                        }
                    )
                }
                Spacer()
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 19)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .task {
            await viewModel.fetchMealStatus()
        }
    }
    
    private var topBarView: some View {
        // 상단 제목 + 버튼
        HStack {
            Text("오늘의 식사 현황")
                .font(.dsTitle3)
                .foregroundStyle(Color.gray080)

            Spacer().frame(height: 24)
            
            if isEditMode {
                // 수정 모드일 때: 수정완료 버튼
                Button(action: {
                    isEditMode = false
                    print("수정완료")
                }, label: {
                    Text("수정완료")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.green060)
                })
            } else {
                // 일반 모드일 때: Menu 버튼
                Menu {
                    Button(action: {
                        isEditMode.toggle()
                        print("수정하기 모드: \(isEditMode ? "켜짐" : "꺼짐")")
                    }, label: {
                        Label("수정하기", systemImage: "pencil")
                    })
                } label: {
                    Image("Home/btn_home_ellipsis")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
}

// MARK: - Meal 기록됐느냐 안됐느냐 상태에 따른 뷰
private struct MealItemView: View {
    let mymeal: MealStatusModel
    let isEditMode: Bool
    let onDelete: () -> Void
    
    var body: some View {
        if mymeal.isRecorded {
            RecordedMealView(meal: mymeal, isEditMode: isEditMode, onDelete: onDelete)
        } else {
            EmptyMealView(meal: mymeal)
        }
    }
}

// MARK: - 기록되지 않은 Meal 뷰
private struct EmptyMealView: View {
    let meal: MealStatusModel

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.gray030)

                Text(meal.displayName)
                    .font(.dsBold15)
                    .foregroundStyle(Color.gray060)
            }
            .frame(width: 60, height: 26)

            Spacer().frame(height: 10)
            
            Button(action: {
                // TODO: 기록 추가 (앨범 여는 액션?)
                print("식사현황 기록하기")
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray020)
                        .frame(width: 76, height: 76)

                    Image("Home/btn_home_add")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            })
        }
    }
}
// MARK: - 기록된 Meal 뷰
private struct RecordedMealView: View {
    let meal: MealStatusModel
    let isEditMode: Bool
    let onDelete: () -> Void

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.green050)
                Text(meal.displayName)
                    .font(.dsBold15)
                    .foregroundStyle(Color.white)
            }
            .frame(width: 60, height: 26)

            Spacer().frame(height: 10)

            ZStack {
                if let imageName = meal.imageName {
                    Rectangle()
                        .remoteImage(url: imageName)
                        .frame(width: 76, height: 76)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green010)
                        .frame(width: 76, height: 76)
                }
                if isEditMode {
                    Color.black.opacity(0.5)
                        .frame(width: 76, height: 76)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            onDelete()
                        }
                    Image("Home/btn_home_deleted")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color.white)
                        .onTapGesture {
                            onDelete()
                        }
                }
            }
        }
    }
}

#Preview {
    MealStatusView(container: .init())
}
