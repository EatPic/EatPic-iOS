//
//  NotificationView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        
        // 상단바
        RoundedRectangle(cornerRadius: 0)
            .frame(height: 56)
        
        ScrollView {
            LazyVStack(spacing: 0) {
                /// 더미데이터에 이 값을 넣어놓고 For Each 문으로 불러오게 
                LikeNotiView(friendNickname: "absdfsdfcd", notiTime: "21시간 전", state: .clicked)

                FollowNotiView(friendNickname: "aaa", notiTime: "23시간", state: .unclicked)
                
                FollowNotiView(friendNickname: "bbbjhjjkjkjk", notiTime: "23시간", state: .clicked)
            }
        }
        // 커스텀 네비게이션 바 적용 안됨 이슈
        .customNavigationBar(title: {
                  HStack {
                Circle().frame(width: 32, height: 32)
                Text("알림")
            }
        }, right: {
            Button {
                print("오른쪽 버튼")
            } label: {
                Image(systemName: "gearshape")
            }
        })
    }
}

#Preview {
    NotificationView()
}
