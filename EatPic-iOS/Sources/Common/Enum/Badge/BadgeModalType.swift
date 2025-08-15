//
//  BadgeModalType.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/19/25.
//

import SwiftUI

/// 뱃지 모달의 상태에 따라 UI 속성을 지정하는 Enum
enum BadgeModalType: ModalBadgeTypeProtocol {
    
    // 뱃지 획득 중 ~ 획득 완료 상태
    case badgeUnlocked(progress: CGFloat, icon: Image)
    // 뱃지 잠금 상태
    case badgeLocked
    // 뱃지 완성 상태
    case badgeCompleted

    // 뱃지 획득 상태에 따라 불러오는 뱃지 뷰
    var badgeView: AnyView {
        switch self {
        case .badgeUnlocked(let progress, let icon):
            let badgeCircleSize = 130 * 0.92 // locked와 badge크기 맞추기 위한 값
            return AnyView(CircleProgressView(
                progress: progress,
                lineWidth: badgeCircleSize * 0.09,
                size: badgeCircleSize,
                icon: icon
            ))
        case .badgeLocked:
            return AnyView(LockBadgeView(size: 130))
        case .badgeCompleted:
            let badgeCircleSize = 130 * 0.92
            return AnyView(CircleProgressView(
                progress: 1.0,
                lineWidth: badgeCircleSize * 0.09,
                size: badgeCircleSize,
                icon: Image(systemName: "checkmark.circle.fill")
            ))
        }
    }

    // 뱃지 획득 상태에 따라 불러오는 버튼 색상
    var buttonColor: Color {
        switch self {
        case .badgeUnlocked: return .green010
        case .badgeLocked: return .gray030
        case .badgeCompleted: return .green050
        }
    }

    // 뱃지 획득 상태에 따라 불러오는 버튼 테두리 색상
    var buttonBorderColor: Color {
        switch self {
        case .badgeUnlocked: return .green060
        case .badgeLocked: return .gray060
        case .badgeCompleted: return .green060
        }
    }

    // 뱃지 획득 상태에 따라 불러오는 버튼 텍스트 색상
    var buttonTextColor: Color {
        switch self {
        case .badgeUnlocked: return .green050
        case .badgeLocked: return .gray060
        case .badgeCompleted: return .white
        }
    }

    // 뱃지 획득 상태에 따라 불러오는 버튼 색상
    var progressText: String {
        switch self {
        case .badgeUnlocked(let progress, _): // 첫번째 연관값 progress만 꺼내고, 두번째 값 icon은 꺼내지 않음(_)
            let value = Int(progress * 10)
            return "\(value)"
        case .badgeLocked:
            return "0"
        case .badgeCompleted:
            return "10"
        }
    }
}
