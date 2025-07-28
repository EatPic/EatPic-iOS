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

// 알림 타입에 따른 UI 차이
extension NotificationType {
    var hasPostImage: Bool {
        switch self {
        case .like, .comment:
            return true  // 좋아요, 댓글은 항상 게시글 이미지가 있음
        case .follow:
            return false // 팔로우는 게시글 이미지가 없음
        }
    }
    
    // 알림 메시지 생성 함수 (문자열 보간 사용)
    func getMessage(for friendNickname: String) -> String {
        switch self {
        case .like:
            return "\(friendNickname) 님이 회원님의 식사 기록에 좋아요를 눌렀습니다."
        case .comment:
            return "\(friendNickname) 님이 회원님의 식사 기록에 댓글을 남겼습니다."
        case .follow:
            return "\(friendNickname) 님이 회원님을 팔로우합니다."
        }
    }
} 