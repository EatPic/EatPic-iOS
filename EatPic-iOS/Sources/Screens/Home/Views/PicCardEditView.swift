//
//  PicCardEditView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

struct PicCardEditView: View {
    var body: some View {
        VStack {
            // 상단바
            HStack {
                Spacer()
                
                Text("수정하기")
                    .font(.dsTitle2)
                
                Spacer().frame(width: 119)
                
                Button(action: {
                    print("RecomPicCardView로 나가기 액션")
                }, label: {
                    Image("Home/btn_home_close")
                })
            }
            .padding(.horizontal, 16)
            
            PicCardWriteView()
        }
    }
}

#Preview {
    PicCardEditView()
}
