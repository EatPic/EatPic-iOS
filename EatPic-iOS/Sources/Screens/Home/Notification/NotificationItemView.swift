//
//  NotificationItemView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

/// 알림 아이템 뷰 (알림 타입에 따라 다른 뷰 표시)
struct NotificationItemView: View {
    let notification: NotificationModel
    let onTap: () -> Void
    let onFollowTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            switch notification.type {
            case .like, .comment:
                LikeNotiView(
                    friendNickname: notification.friendNickname,
                    notiTime: notification.notiTime,
                    state: notification.state,
                    postImageName: notification.postImageName
                )
            case .follow:
                FollowNotiView(
                    friendNickname: notification.friendNickname,
                    notiTime: notification.notiTime,
                    state: notification.state,
                    onFollowTap: onFollowTap
                )
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NotificationItemView(
        notification: NotificationModel(
            friendNickname: "테스트",
            notiTime: "1시간 전",
            state: .unclicked,
            type: .like
        ),
        onTap: { print("알림 클릭") },
        onFollowTap: { print("팔로우 클릭") }
    )
} 