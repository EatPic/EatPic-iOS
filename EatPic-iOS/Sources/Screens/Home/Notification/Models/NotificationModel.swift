//
//  NotificationModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

// 알림 데이터 모델
struct NotificationModel: Identifiable {
    let id: String = UUID().uuidString
    let friendNickname: String
    let notiTime: String
    let state: NotiState
    let type: NotificationType
    let postImageName: String? // 게시글 이미지 (선택사항)
    
    init(
        friendNickname: String,
        notiTime: String,
        state: NotiState,
        type: NotificationType,
        postImageName: String? = nil
    ) {
        self.friendNickname = friendNickname
        self.notiTime = notiTime
        self.state = state
        self.type = type
        self.postImageName = postImageName
    }
}

// 알림 타입 enum
enum NotificationType {
    case like    // 좋아요 알림
    case follow  // 팔로우 알림
    case comment // 댓글 알림
} 