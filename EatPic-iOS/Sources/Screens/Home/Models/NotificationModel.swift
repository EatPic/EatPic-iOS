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
    let state: NotificationState
    let type: NotificationType
    let postImageName: String? // 게시글 이미지 (선택사항)
    
    init(
        friendNickname: String,
        notiTime: String,
        state: NotificationState,
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
