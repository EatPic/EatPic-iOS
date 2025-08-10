//
//  PicCardWrite.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/25/25.
//

// TODO: [25.08.10] 바텀 시트뷰로 인한 linkURL & location(longtitude, latitude) 바인딩 값 추가해야함
import SwiftUI

struct PicCardWriteView: View {
    @EnvironmentObject private var container: DIContainer
    
    let primaryButtonText: String

    // ✅ 내부 @State 제거, 외부에서 바인딩으로 주입
    @Binding var myMemo: String
    @Binding var receiptDetail: String
    @Binding var isSharedToFeed: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 24)

            Text("나의 메모")
                .font(.dsHeadline)
                .foregroundStyle(Color.gray080)

            Spacer().frame(height: 8)

            TextAreaView(
                text: $myMemo,
                placeholder: "잇친들과 공유할 나의 메모를 입력해주세요.",
                height: 150
            )

            Spacer().frame(height: 24)

            Text("레시피 내용")
                .font(.dsHeadline)
                .foregroundStyle(Color.gray080)

            Spacer().frame(height: 8)

            TextAreaView(
                text: $receiptDetail,
                placeholder: "잇친들과 공유할 레시피 내용을 입력해주세요.",
                height: 150
            )

            Spacer().frame(height: 20)

            VStack(spacing: 0) {
                AddButtonView(
                    btnImage: Image("PicCardWrite/ic_record_link"),
                    btnTitle: "레시피 링크 추가",
                    action: {
                        // TODO: [25.08.10]  BottomSheetView 추가
                        // TODO: [25.08.10] 링크 추가했다면 레시피 링크 추가 텍스트 부분에 해당 링크 뜨도록
                        print("링크 추가하기")
                    }
                )

                AddButtonView(
                    btnImage: Image("PicCardWrite/ic_record_map"),
                    btnTitle: "식당 위치 추가",
                    action: {
                        // TODO: [25.08.10]  BottomSheetView 추가
                        // TODO: [25.08.10] 위치 추가했다면 텍스트 부분에 해당 식당 이름 뜨도록
                    }
                )

                ShareToFeedButton(
                    isOn: $isSharedToFeed,
                    action: { _ in
                        // TODO: [25.08.10] 피드 공유하기 여부 액션??
                    }
                )
            }

            Spacer().frame(height: 34)

            PrimaryButton(
                color: .green060,
                text: primaryButtonText,
                font: .dsTitle3,
                textColor: .white,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                container.router.popToRoot()
            }
        }
        .padding(.horizontal, 16)
    }
}
// MARK: 레시피 링크 또는 식당 위치 추가 공용버튼 뷰
private struct AddButtonView: View {
    let btnImage: Image
    let btnTitle: String
    let action: () -> Void
    
    // MARK: - Init
    init(
        btnImage: Image,
        btnTitle: String,
        action: @escaping () -> Void
    ) {
        self.btnImage = btnImage
        self.btnTitle = btnTitle
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            btnImage
                .resizable()
                .frame(width: 24, height: 24)
            
            Spacer().frame(width: 8)
            
            Text(btnTitle)
                .font(.dsBody)
                .foregroundStyle(Color.gray080)
            
            Spacer()
            
            Button(action: {
                action()
            }, label: {
                Image("PicCardWrite/add_btn")
            })
            
            Spacer().frame(width: 12)
        }
        .padding(.vertical, 18)
    }
}

// MARK: 피드 공유 버튼 뷰
private struct ShareToFeedButton: View {
    @Binding var isOn: Bool
    let action: (Bool) -> Void
    
    // MARK: - Init
    init(
        isOn: Binding<Bool>,
        action: @escaping (Bool) -> Void
    ) {
        self._isOn = isOn
        self.action = action
    }

    var body: some View {
        HStack {
            Image("PicCardWrite/ic_record_share")
                .resizable()
                .frame(width: 24, height: 24)
            
            Spacer().frame(width: 8)
            
            Text("피드에 공유하기")
                .font(.dsBody)
                .foregroundStyle(Color.gray080)
            
            Spacer().frame(width: 12)
                     
            Text("피드에 공유하기")
                .font(.dsCaption1)
                .foregroundStyle(Color.gray060)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .pink060))
                .labelsHidden()
                .onChange(of: isOn) { _, newValue in
                    if newValue {
                        print("피드 공유하기 on")
                    } else {
                        print("피드 공유하기 off")
                    }
                    action(newValue)
                }
                
            Spacer().frame(width: 6)
        }
        .padding(.vertical, 18)
    }
}

#Preview {
    // 프리뷰 전용 State 값
    @Previewable @State var memo = "샘플 메모"
    @Previewable @State var recipe = "샘플 레시피"
    @Previewable @State var isShared = false
    
    return PicCardWriteView(
        primaryButtonText: "수정하기",
        myMemo: $memo,
        receiptDetail: $recipe,
        isSharedToFeed: $isShared
    )
}
