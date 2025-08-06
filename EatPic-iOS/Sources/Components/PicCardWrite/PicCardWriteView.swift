//
//  PicCardWrite.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/25/25.
//

import SwiftUI

// MARK: PicCard 내용 기록 뷰
struct PicCardWriteView: View {
    let primaryButtonText: String
    
    init(
        primaryButtonText: String
    ) {
        self.primaryButtonText = primaryButtonText
        
    }
    
    @State private var myMemo: String = ""
    @State private var receiptDetail: String = ""
    @State private var isSharedToFeed: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Spacer().frame(height: 24)
            
            Text("나의 메모")
                .font(.dsHeadline)
                .foregroundColor(.gray080)
            
            Spacer().frame(height: 8)
            
            TextAreaView(
                text: $myMemo,
                placeholder: "잇친들과 공유할 나의 메모를 입력해주세요.",
                height: 150
            )
            
            Spacer().frame(height: 24)
            
            Text("레시피 내용")
                .font(.dsHeadline)
                .foregroundColor(.gray080)
            
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
                        print("링크 추가하기")
                        // [25.08.05] TODO: 클릭 시 링크 추가 바텀 시트뷰 뜨도록 액션 - 비엔/이은정
                        // TODO: 바텀시트 뜬 이후 링크 추가 되도록
                    }
                )
                
                AddButtonView(
                    btnImage: Image("PicCardWrite/ic_record_map"),
                    btnTitle: "식당 위치 추가",
                    action: {
                        print("위치 추가하기")
                        // TODO: 클릭 시 식당위치 추가 바텀 시트뷰 뜨도록 액션
                        // TODO: 바텀시트 뜬 이후 위치 추가 되도록
                    }
                )
                
                ShareToFeedButton(
                    isOn: $isSharedToFeed,
                    action: { isShared in
                        if isShared {
                            print("피드에 공유하기")
                        } else {
                            print("피드에 공유하기 끔")
                        }
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
                cornerRadius: 10,
                action: {
                    print("\(primaryButtonText)")
                }
            )
            
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
                .foregroundColor(.gray080)
            
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
                .foregroundColor(.gray080)
            
            Spacer().frame(width: 12)
                     
            Text("피드에 공유하기")
                .font(.dsCaption1)
                .foregroundColor(.gray060)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .pink060))
                .labelsHidden()
                .onChange(of: isOn) { _, newValue in
                    action(newValue)
                }
                
            Spacer().frame(width: 6)
        }
        .padding(.vertical, 18)
    }
}

#Preview {
    PicCardWriteView(
        primaryButtonText: "수정하기"
    )
}
