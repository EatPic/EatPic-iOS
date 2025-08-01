//
//  MealStatusView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/22/25.
//

import SwiftUI

// MARK: - 메인 뷰
struct MealStatusView: View {
    @StateObject private var viewModel = MealStatusViewModel()
    
    var body: some View {
        VStack {
            // 상단 제목 + 버튼
            HStack {
                Text("오늘의 식사 현황")
                    .font(.dsTitle3)
                    .foregroundColor(.gray080)

                Spacer().frame(height: 24)
                
                Menu {
                    Button(action: {
                        // TODO: ZStack으로 현재 사진이 들어간 부분 위에 x 표시 떠야함, 그리고 그 x표시 누르면 사진 삭제 되어야함 < 어케 해야할지????
                        print("수정하기")
                    }, label: {
                        Label("수정하기", systemImage: "pencil")
                    })
                } label: {
                    Image("Home/btn_home_ellipsis")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }

            Spacer().frame(height: 24)

            // 식사 항목 리스트
            HStack(spacing: 6) {
                ForEach(viewModel.mealStatus) { meal in
                    MealItemView(mymeal: meal)
                }
                Spacer()
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 19)
        .background(.white)
        .cornerRadius(15)
    }
}

// MARK: - Meal 기록됐느냐 안됐느냐 상태에 따른 뷰
private struct MealItemView: View {
    let mymeal: MealStatusModel
    
    var body: some View {
        if mymeal.isRecorded {
            RecordedMealView(meal: mymeal)
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

                Text(meal.mealTime)
                    .font(.dsBold15)
                    .foregroundColor(.gray060)
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

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.green050)

                Text(meal.mealTime)
                    .font(.dsBold15)
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 26)

            Spacer().frame(height: 10)

            if let imageName = meal.imageName {
                Image(imageName) // Model에서 가져온 이미지
                    .resizable()
                    .frame(width: 76, height: 76)
                    .cornerRadius(10)
            } else {
                // 기본 이미지 또는 placeholder
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green010)
                    .frame(width: 76, height: 76)
            }
        }
    }
}

#Preview {
    MealStatusView()
}
