import SwiftUI

struct MealtimeSelectView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewmodel: PicCardRecorViewModel

    // 현재 화면에서 선택된 식사 시간
    @State private var selectedMeal: MealTime?

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
            VStack(spacing: 24) {
                HStack(spacing: 21) {
                    MealButton(mealType: .breakfast, isSelected: selectedMeal == .breakfast) {
                        toggle(.breakfast)
                    }
                    MealButton(mealType: .lunch, isSelected: selectedMeal == .lunch) {
                        toggle(.lunch)
                    }
                }
                HStack(spacing: 21) {
                    MealButton(mealType: .dinner, isSelected: selectedMeal == .dinner) {
                        toggle(.dinner)
                    }
                    MealButton(mealType: .snack, isSelected: selectedMeal == .snack) {
                        toggle(.snack)
                    }
                }
            }

            Spacer().frame(height: 102)

            // 하단 다음 버튼
            PrimaryButton(
                color: selectedMeal == nil ? .gray020 : .green060,
                text: "다음",
                font: .dsTitle3,
                textColor: selectedMeal == nil ? .gray040 : .white,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                if let meal = selectedMeal {
                    viewmodel.updateMealTime(meal)
                    container.router.push(.hashtagSelection(selectedMeal: meal))
                }
            }
            // 선택값 없으면 버튼 비활성화
            .disabled(selectedMeal == nil)
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

    // 식사 버튼 토글
    // 같은 버튼 누르면 해제, 다시 다른 버튼 누르면 변경
    private func toggle(_ meal: MealTime) {
        selectedMeal = (selectedMeal == meal) ? nil : meal
    }
}

// MARK: - 식사 시간 버튼 (아침 ~간식)
struct MealButton: View {
    let mealType: MealTime // 아침, 점심, 저녁, 간식
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
    MealtimeSelectView()
        .environmentObject(PicCardRecorViewModel())
}
