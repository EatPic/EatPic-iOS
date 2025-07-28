//
//  NotificationViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

/// 알림 화면의 ViewModel
@Observable
class NotificationViewModel {
    
    // MARK: - Property
    
    /// 알림 목록
    var notifications: [NotificationModel] = []
    
    // MARK: - Init
    
    init() {
        loadNotificationData()
    }
    
    // MARK: - Methods
    
    /// 알림 데이터 로드
    private func loadNotificationData() {
        notifications = [
            // 좋아요 알림
            NotificationModel(
                friendNickname: "absdfsdfcd",
                notiTime: "21시간 전",
                state: .clicked,
                type: .like,
                postImageName: "sample_post_1"
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
                friendNickname: "댓글러",
                notiTime: "1시간 전",
                state: .unclicked,
                type: .comment,
                postImageName: "sample_post_2"
            )
        ]
    }
    
    /// 알림 상태 변경 (클릭됨/클릭안됨)
    func toggleNotificationState(for notificationId: String) {
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            let currentState = notifications[index].state
            let newState: NotiState = currentState == .clicked ? .unclicked : .clicked
            
            notifications[index] = NotificationModel(
                friendNickname: notifications[index].friendNickname,
                notiTime: notifications[index].notiTime,
                state: newState,
                type: notifications[index].type,
                postImageName: notifications[index].postImageName
            )
        }
    }
    
    /// 팔로우 버튼 액션
    func followButtonTapped(for notificationId: String) {
        print("팔로우 버튼 클릭됨: \(notificationId)")
        // TODO: 팔로우/언팔로우 로직 구현
    }
} 