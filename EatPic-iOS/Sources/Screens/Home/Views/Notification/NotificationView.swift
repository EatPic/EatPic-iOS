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

private struct NotificationItemView: View {
    let notification: NotificationModel
    let onTap: () -> Void
    let onFollowTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            switch notification.type {
            case .like, .comment:
                // LikeNotiView 내용 직접 작성
                HStack {
                    ProfileImageView(size: 47)
                    Spacer().frame(width: 16)
                    (
                        Text(
                            "\(notification.friendNickname) 님이 회원님의 식사 기록에 "
                            + (notification.type == .like ? "좋아요를 눌렀습니다." : "댓글을 남겼습니다.")
                        )
                            .foregroundColor(.gray080)
                            .font(.dsFootnote)
                        +
                        Text("\(notification.notiTime) 전")
                            .foregroundColor(.gray060)
                            .font(.dsFootnote)
                    )
                    Spacer()
                    // 좋아요, 댓글 알림은 항상 이미지가 있음
                    if let postImageName = notification.postImageName {
                        Image(postImageName)
                            .resizable()
                            .frame(width: 47, height: 47)
                            .cornerRadius(4)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(notification.state.backgroundColor)

            case .follow:
                // FollowNotiView 내용 직접 작성
                HStack {
                    ProfileImageView(size: 47)
                    Spacer().frame(width: 16)
                    VStack(alignment: .leading) {
                        Text("\(notification.friendNickname) 님이 회원님을 팔로우합니다.")
                            .foregroundColor(.gray080)
                            .font(.dsFootnote)
                        Text("\(notification.notiTime) 전")
                            .foregroundColor(.gray060)
                            .font(.dsFootnote)
                    }
                    Spacer()
                    Button(action: onFollowTap) {
                        Text("팔로잉")
                            .foregroundColor(notification.state.followButtonTextColor)
                            .font(.dsBold15)
                            .frame(width: 64, height: 28)
                    }
                    .background(notification.state.followButtonColor)
                    .cornerRadius(5)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(notification.state.backgroundColor)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NotificationView()
}
