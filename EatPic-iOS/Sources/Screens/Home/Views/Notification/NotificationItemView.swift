////
////  NotificationItemView.swift
////  EatPic-iOS
////
////  Created by 이은정 on 7/27/25.
////
//
import SwiftUI

struct NotificationItemView: View {
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

#Preview("좋아요 알림") {
    NotificationItemView(
        notification: NotificationModel(
            friendNickname: "잇콩",
            notiTime: "1시간",
            state: .unclicked,
            type: .like,
            postImageName: "Home/img1"
        ),
        onTap: { print("알림 클릭") },
        onFollowTap: { print("팔로우 클릭") }
    )
}

#Preview("댓글 알림") {
    NotificationItemView(
        notification: NotificationModel(
            friendNickname: "잇콩",
            notiTime: "2시간",
            state: .clicked,
            type: .comment,
            postImageName: "Home/img1"
        ),
        onTap: { print("알림 클릭") },
        onFollowTap: { print("팔로우 클릭") }
    )
}

#Preview("팔로우 알림") {
    NotificationItemView(
        notification: NotificationModel(
            friendNickname: "잇콩",
            notiTime: "3시간",
            state: .unclicked,
            type: .follow
        ),
        onTap: { print("알림 클릭") },
        onFollowTap: { print("팔로우 클릭") }
    )
}
