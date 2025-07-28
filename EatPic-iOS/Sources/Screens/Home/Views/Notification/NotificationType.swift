//
//  NotificationType.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

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
    
    var buttonTitle: String? {
        switch self {
        case .follow:
            return "팔로잉"
        case .like, .comment:
            return nil  // 좋아요, 댓글은 버튼이 없음
        }
    }
}
