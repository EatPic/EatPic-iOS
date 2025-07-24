//
//  MyMemoView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

// CalenderCardView에서 나의 메모 버튼을 누르면 보이는 뷰 
import SwiftUI

struct MyMemoView: View {
    @State var sampleText = ""

    var body: some View {
        
        VStack {
            Spacer().frame(height: 32)
            
            TextAreaView(
                text: $sampleText,
                height: 417
            )
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .customNavigationBar(title: {
            HStack {
                      Text("나의 메모")
                  }
              }, right: {
                  
              })
    }
}

#Preview {
    MyMemoView()
}

