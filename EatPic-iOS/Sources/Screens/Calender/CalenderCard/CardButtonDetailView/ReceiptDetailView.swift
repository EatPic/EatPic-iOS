//
//  ReceiptDetailView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

// CalenderCardView에서 레시피 내용 버튼을 누르면 보이는 뷰 
import SwiftUI

struct ReceiptDetailView: View {
    @State var receiptText = ""

    var body: some View {
        
        VStack {
            Spacer().frame(height: 32)
            
            TextAreaView(
                text: $receiptText,
                height: 417
            )
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .customNavigationBar {
            Text("레시피 내용")
                .font(.dsTitle2)
                .foregroundStyle(Color.gray080)
        } right: {
            EmptyView()
        }
    }
}

#Preview {
    ReceiptDetailView()
}
