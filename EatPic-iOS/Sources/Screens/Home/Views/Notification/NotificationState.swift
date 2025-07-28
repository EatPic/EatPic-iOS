//
//  NotificationState.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//
import SwiftUI

// 알림 메시지를 클릭했을 때와 클릭하지 않았을 때의 상태
enum NotificationState {
    case unclicked
    case clicked
}

// 클릭 상태에 따른 UI 차이
extension NotificationState {
    var backgroundColor: Color {
        switch self {
        case .unclicked: return .green020
        case .clicked: return .white
        }
    }
    
    var followButtonColor: Color {
        switch self {
        case .unclicked: return .green060
        case .clicked: return .gray030
        }
    }
    
    var followButtonTextColor: Color {
        switch self {
        case .unclicked: return .white
        case .clicked: return .gray050
        }
    }
}
