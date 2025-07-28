//
//  MyMemoView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

// CalenderCardView에서 나의 메모 버튼을 누르면 보이는 뷰 
import SwiftUI

struct MyMemoView: View {
    // FIXME: 여기 Text내용은 이미 서버에서 불러와져야 하는 내용임 (PicCardView를 기록했었을 때 저장됐어야 했을 메모 내용)
    @State var myMemo = ""

    var body: some View {
        
        VStack {
            Spacer().frame(height: 32)
            
            
            TextAreaView(
                // FIXME: 여기 Text내용은 이미 서버에서 불러와져야 하는 내용임 (PicCardView를 기록했었을 때 저장됐어야 했을 메모 내용)
                text: $myMemo,
                height: 417
            )
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .customNavigationBar {
            Text("나의 메모")
                .font(.dsTitle2)
                .foregroundColor(Color.gray080)
        } right: {
            EmptyView()
        }
    }
}

#Preview {
    MyMemoView()
}
