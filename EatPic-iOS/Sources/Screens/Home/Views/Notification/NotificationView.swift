//
//  NotificationView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ReplyNotiView(friendNickname: "bbbjhjjkjkjk",
                               notiTime: "23시간")
                
                CommentNotiView(friendNickname: "bbbjhjjkjkjk",
                               notiTime: "23시간")
                
                LikeNotiView(friendNickname: "absdfsdfcd",
                             notiTime: "21시간")
                
                FollowNotiView(friendNickname: "aaa",
                               notiTime: "23시간")

            }
        }
        .customNavigationBar(title: {
            HStack {
                Text("알림")
            }
        }, right: {
            EmptyView()
        })
    }
}

#Preview {
    NotificationView()
}
