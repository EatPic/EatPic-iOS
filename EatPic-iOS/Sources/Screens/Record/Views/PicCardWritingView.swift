//
//  PicCardWritingView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

//
//  PicCardEditView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

struct PicCardWritingView: View {
    var body: some View {
        VStack {
            // 상단바
            HStack {
                Spacer()
                
                Text("Pic 카드 기록")
                    .font(.dsTitle2)
                
                Spacer().frame(width: 119)
                
                Button(action: {
                    // TODO: RecomPicCardView로 Navigation
                }, label: {
                    Image("Record/btn_home_close")
                })
            }
            .padding(.horizontal, 16)
            
            PicCardWriteView()
            // FIXME: PicCardWriteView placeholder여백 왜이럼
            // FIXME: PicCardWriteView FocusState으로 처리
            // FIXME: PicCardWriteView PrimarybuttonText 매개변수 처리
            // FIXME: PicCardWriteView의 PrimarybuttonAction 매개변수 처리 ( 추후 CommunityMain으로 Navigation )
        }
    }
}

#Preview {
    PicCardWritingView()
}
