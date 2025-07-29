//
//  LikeNotificationListView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

/// 좋아요 알림만을 모아서 보여주는 리스트 뷰
struct LikeNotificationListView: View {
    // MARK: - Property
    @StateObject private var viewModel = NotificationViewModel()
    
    // 좋아요 알림만 필터링
    private var likeNotifications: [NotificationModel] {
        viewModel.notifications.filter { $0.type == .like }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(likeNotifications) { notification in
                    LikeNotificationView(
                        notification: notification,
                        onTap: {
                            // TODO: 좋아요 알림 클릭 시 해당 Pic카드 화면으로 이동
                            print("좋아요 알림 클릭됨: \(notification.friendNickname)")
                        }
                    )
                }
            }
        }
        .customNavigationBar(title: {
            HStack {
                Circle().frame(width: 32, height: 32)
                Text("좋아요 알림")
            }
        }, right: {
            Button {
                print("설정 버튼")
            } label: {
                Image(systemName: "gearshape")
            }
        })
    }
}

#Preview {
    LikeNotificationListView()
} 