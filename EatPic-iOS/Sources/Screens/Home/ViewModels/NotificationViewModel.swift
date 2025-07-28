//
//  NotificationViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

/// 알림 화면의 ViewModel
class NotificationViewModel: ObservableObject {
    
    // MARK: - Property
    
    /// 알림 목록
    @Published var notifications: [NotificationModel] = [
        // 좋아요 알림
        NotificationModel(
            friendNickname: "absdfsdfcd",
            notiTime: "21시간 전",
            state: .clicked,
            type: .like,
            postImageName: "Home/img1"
        ),
        
        // 팔로우 알림
        NotificationModel(
            friendNickname: "aaa",
            notiTime: "23시간",
            state: .unclicked,
            type: .follow
        ),
        
        // 팔로우 알림 (클릭됨)
        NotificationModel(
            friendNickname: "bbbjhjjkjkjk",
            notiTime: "23시간",
            state: .clicked,
            type: .follow
        ),
        
        // 댓글 알림
        NotificationModel(
            friendNickname: "lkajsdoi",
            notiTime: "1시간 전",
            state: .unclicked,
            type: .comment,
            postImageName: "Home/img1"
        )
    ]
} 
