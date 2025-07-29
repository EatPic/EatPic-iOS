//
//  LikeNotificationView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

/// 좋아요 알림을 위한 전용 뷰
struct LikeNotificationView: View {
    let notification: NotificationModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // 프로필 이미지
                ProfileImageView(size: 47)
                
                // 알림 내용
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(notification.friendNickname)
                            .foregroundColor(.gray080)
                            .font(.dsFootnote)
                            .fontWeight(.medium)
                        
                        Text("님이 회원님의 식사 기록에 좋아요를 눌렀습니다.")
                            .foregroundColor(.gray080)
                            .font(.dsFootnote)
                    }
                    
                    Text(notification.notiTime)
                        .foregroundColor(.gray060)
                        .font(.dsFootnote)
                }
                
                Spacer()
                
                // 게시글 이미지
                if let postImageName = notification.postImageName {
                    Image(postImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 47, height: 47)
                        .cornerRadius(4)
                        .clipped()
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(notification.state.backgroundColor)
        }
        .buttonStyle(.plain)
    }
}

#Preview("좋아요 알림 - 클릭되지 않음") {
    LikeNotificationView(
        notification: NotificationModel(
            friendNickname: "잇콩",
            notiTime: "1시간 전",
            state: .unclicked,
            type: .like,
            postImageName: "Home/img1"
        ),
        onTap: { print("좋아요 알림 클릭") }
    )
    .previewLayout(.sizeThatFits)
}

#Preview("좋아요 알림 - 클릭됨") {
    LikeNotificationView(
        notification: NotificationModel(
            friendNickname: "맛있는사람",
            notiTime: "30분 전",
            state: .clicked,
            type: .like,
            postImageName: "Home/img1"
        ),
        onTap: { print("좋아요 알림 클릭") }
    )
    .previewLayout(.sizeThatFits)
} 