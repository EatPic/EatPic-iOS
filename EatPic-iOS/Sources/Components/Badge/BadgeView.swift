//
//  BadgeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/16/25.
//
//
import SwiftUI

/// 1. progress 상태, 2. locked 상태 이 상태들의 공통점을 뽑아내어 하나의 덩어리를 구성한다.
/// progress 상태와 locked상태의 공통점 분석
/// 1.  원형으로 background(Circle)가 구성되어있음
/// 2. 원형안에 이미지 존재
/// 3. 원형뱃지 밑에 text값 존재
/// 뱃지 상태 ( progress : 뱃지 획득 중 ~ 획득 완료) , locked ( 뱃지 획득 이전), completed (뱃지 완성)
enum BadgeState {
    case progress(progress: Double, iconURL: String)
    case locked
    case completed(iconURL: String)
}

/// 상단에 CircleProgressView 또는 LockBadgeView, 하단에 뱃지 이름을 띄워주는 뷰입니다
///   - Parameters:
///   - state: 현재 뱃지 상태로 progress : 뱃지 획득 중 ~ 획득 완료) , locked ( 뱃지 획득 이전) 중 하나입니다
///   - badgeName: 뱃지 이름입니다.
///   - size: 뱃지의 사이즈 입니다.
struct BadgeView: View {
    let state: BadgeState
    let badgeName: String
    let size: CGFloat

    init(state: BadgeState, badgeName: String, size: CGFloat = 130) {
        self.state = state
        self.badgeName = badgeName
        self.size = size
    }

    var body: some View {
        VStack {
            let badgeCircleSize = size * 0.92
            let iconSize = badgeCircleSize * 0.68

            switch state {
            case .progress(let progress, let iconURL):
                CircleProgressView(
                    progress: progress,
                    lineWidth: badgeCircleSize * 0.09,
                    size: badgeCircleSize,
                    iconURL: iconURL,
                    iconSize: iconSize
                )

            case .locked:
                LockBadgeView(size: size)

            case .completed(let iconURL):
                CircleProgressView(
                    progress: 1.0,
                    lineWidth: badgeCircleSize * 0.09,
                    size: badgeCircleSize,
                    iconURL: iconURL,                 
                    iconSize: iconSize
                )
            }

            Spacer()

            Text(badgeName)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray080)
        }
        .frame(width: 130, height: 156)
    }
}
