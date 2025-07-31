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

struct PicCardRecordView: View {
    // 바텀 시트 표시 여부
    @State private var showHashtagAddSheet = false

    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        VStack {
            PicCardWriteView()
            // FIXME: [25.07.30] PicCardWriteView placeholder여백 - 비엔/이은정
            // FIXME: [25.07.30] PicCardWriteView FocusState으로 처리 - 비엔/이은정
            // FIXME: [25.07.30] 모든 버튼 클로저 처리
            // FIXME: [25.07.30] - 비엔/이은정 PicCardWriteView PrimarybuttonText 매개변수 처리 - 비엔/이은정
            // FIXME: [25.07.30] PicCardWriteView의 PrimarybuttonAction 매개변수 처리 ( 추후 CommunityMain으로 Navigation ) - 비엔/이은정
        }
        .customNavigationBar {
            Text("Pic 카드 기록")
        } right: {
            Button(action: {
                container.router.push(.home)
            }, label: {
                Image("Record/btn_home_close")
            })
        }
    }
}

#Preview {
    PicCardRecordView()
}
