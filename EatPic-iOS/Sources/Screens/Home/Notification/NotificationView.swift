//
//  NotificationView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct NotificationView: View {
    // MARK: - Property
    @State private var viewModel = NotificationViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.notifications) { notification in
                    NotificationItemView(
                        notification: notification,
                        onTap: {
                            viewModel.toggleNotificationState(for: notification.id)
                        },
                        onFollowTap: {
                            viewModel.followButtonTapped(for: notification.id)
                        }
                    )
                }
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
