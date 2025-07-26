//
//  PicCardWrite.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/25/25.
//

import SwiftUI

// MARK: PicCard 내용 기록 뷰
struct PicCardWriteView: View {
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
                // placeholder: "잇친들과 공유할 나의 메모를 입력해주세요."
                height: 150
            )
            
            Spacer().frame(height: 24)
            
            Text("레시피 내용")
                .font(.dsHeadline)
                .foregroundColor(.gray080)
            
            Spacer().frame(height: 8)
            
            TextAreaView(
                text: $receiptDetail,
                // placeholder: "잇친들과 공유할 레시피 내용을 입력해주세요."
                height: 150
            )
            
            Spacer().frame(height: 20)
            
            VStack(spacing: 0) {
                AddButtonView(btnImage: Image("PicCardWrite/ic_record_link"), btnTitle: "레시피 링크 추가")
                
                AddButtonView(btnImage: Image("PicCardWrite/ic_record_map"), btnTitle: "식당 위치 추가")
                
                ShareToFeedButton(isOn: $isSharedToFeed)
            }
            
            Spacer().frame(height: 34)
            
            PrimaryButton(color: .green060,
                          text: "저장하기",
                          font: .dsTitle3,
                          textColor: .white,
                          width: 361,
                          height: 48,
                          cornerRadius: 10,
                          action: { print("버튼액션") })
            
        }
        .padding(.horizontal, 16)
    }
}

// MARK: 레시피 링크 또는 식당 위치 추가 공용버튼 뷰
private struct AddButtonView: View {
    let btnImage: Image
    let btnTitle: String
    
    // MARK: - Init
    init(
        btnImage: Image,
        btnTitle: String
    ) {
        self.btnImage = btnImage
        self.btnTitle = btnTitle
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
                print("\(btnTitle)하기")
            }, label: {
                Image("Record/add_btn")
            })
            
            Spacer().frame(width: 12)
        }
        .padding(.vertical, 18)
    }
}

// MARK: 피드 공유 버튼 뷰
private struct ShareToFeedButton: View {
    @Binding var isOn: Bool

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
                .onChange(of: isOn) {
                    print("피드에 공유하기 활성화")
                    // 피드에 공유하기 액션 추가
                }
                
            Spacer().frame(width: 6)
        }
        .padding(.vertical, 18)
    }
}

#Preview {
    PicCardWriteView()
}
