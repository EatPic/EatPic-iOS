//
//  NotiFollowState.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

// 알림 메시지의 팔로우 버튼를 클릭했을 때와 클릭하지 않았을 때의 상태
// 추후 사용..
enum NotiFollowState {
    case unfollow
    case follow
}

// 클릭 상태에 따른 UI 차이
extension NotiFollowState {
    
    var followButtonColor: Color {
        switch self {
        case .unfollow: return .green060
        case .follow: return .gray030
        }
    }
    
    var followButtonTextColor: Color {
        switch self {
        case .unfollow: return .white
        case .follow: return .gray050
        }
    }
}
