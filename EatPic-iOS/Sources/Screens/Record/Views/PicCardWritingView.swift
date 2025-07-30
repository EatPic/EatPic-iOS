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
            PicCardWriteView()
            // FIXME: PicCardWriteView placeholder여백 왜이럼
            // FIXME: PicCardWriteView FocusState으로 처리
            // FIXME: PicCardWriteView PrimarybuttonText 매개변수 처리
            // FIXME: PicCardWriteView의 PrimarybuttonAction 매개변수 처리 ( 추후 CommunityMain으로 Navigation )
        }
        .customNavigationBar {
            Text("Pic 카드 기록")
        } right: {
            Button(action: {
                // FIXME: 기존에 내가 열고 있던 화면으로 Navigation (????)
            }, label: {
                Image("Record/btn_home_close")
            })
        }
    }
}

#Preview {
    PicCardWritingView()
}
