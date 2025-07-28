//
//  ReceiptDetailView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

// CalenderCardView에서 레시피 내용 버튼을 누르면 보이는 뷰 
import SwiftUI

struct ReceiptDetailView: View {
    // FIXME: 여기 Text내용은 이미 서버에서 불러와져야 하는 내용임 (PicCardView를 기록했었을 때 저장됐어야 했을 레시피 내용)
    @State var receiptText = ""

    var body: some View {
        
        VStack {
            Spacer().frame(height: 32)
            
            TextAreaView(
                // FIXME: 여기 Text내용은 이미 서버에서 불러와져야 하는 내용임 (PicCardView를 기록했었을 때 저장됐어야 했을 레시피 내용)
                text: $receiptText,
                height: 417
            )
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .customNavigationBar {
            Text("레시피 내용")
                .font(.dsTitle2)
                .foregroundColor(Color.gray080)
        } right: {
            EmptyView()
        }
    }
}

#Preview {
    ReceiptDetailView()
}
