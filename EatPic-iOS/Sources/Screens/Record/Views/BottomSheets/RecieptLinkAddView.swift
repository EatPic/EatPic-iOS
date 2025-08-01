//
//  RecieptLinkAddView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

struct RecieptLinkAddView: View {
    @State private var linkInput: String = ""
    
    var body: some View {
        TopBanner()
        
        Spacer().frame(height: 78)

        HStack {
            TextAreaView(
                text: $linkInput,
                placeholder: "최대 5글자 입력",
                height: 40
            )
            
            Spacer().frame(width: 9)
            
            PrimaryButton(
                color: .green060,
                text: "추가",
                font: .dsHeadline,
                textColor: .white,
                width: 64,
                height: 40,
                cornerRadius: 10
            ) {
                // TODO: 레시피 링크 추가 액션
            }
        }
        .padding(.horizontal, 19)
    }
}

private struct TopBanner: View {
    var body: some View {
        VStack {
            ZStack {
                Text("레시피 링크 추가")
                    .font(.dsTitle2)

                HStack {
                    Spacer()
                    Button(action: {
                        // TODO: RecomPicCardView로 Navigation
                    }, label: {
                        Image("Record/btn_home_close")
                    })
                }
            }
            .padding(.horizontal, 19)
        }
    }
}

#Preview {
    RecieptLinkAddView()
}
