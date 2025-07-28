//
//  NotificationView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct NotificationView: View {
    // MARK: - Property
    @StateObject private var viewModel = NotificationViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.notifications) { notification in
                    NotificationItemView(
                        notification: notification,
                        onTap: {
                            // TODO: 알림 버튼 클릭 함수 생성 (근데 이거 댓글, 좋아요일 경우 해당 Pic카드 화면 이동, 팔로우일 경우 그사람으로)
                            print("알림 클릭됨")
                        },
                        onFollowTap: {
                            // TODO: 팔로우 버튼 클릭 기능 함수 생성
                            print("팔로우 버튼 클릭됨")
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
