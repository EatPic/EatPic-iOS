//
//  BadgeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/16/25.
//
//
import SwiftUI


/// 뱃지 상태 ( progress : 뱃지 획득 중 ~ 획득 완료) , locked ( 뱃지 획득 이전)
enum BadgeState {
    case progress(progress: CGFloat, icon: Image)
    case locked
}


/// 상단에 CircleProgressView 또는 LockBadgeView, 하단에 뱃지 이름을 띄워주는 뷰입니다
///   - Parameters:
///   - state: 현재 뱃지 상태로 progress : 뱃지 획득 중 ~ 획득 완료) , locked ( 뱃지 획득 이전) 중 하나입니다
///   - badgeName: 뱃지 이름입니다.
///   - size: 뱃지의 사이즈 입니다.
struct BadgeView: View {
    // 뱃지 상태
    let state: BadgeState
    
    // 뱃지 이름
    let badgeName: String
    
    // 뱃지 사이즈
    let size: CGFloat

    init(
        state: BadgeState,
        badgeName: String,
        size: CGFloat = 130
    ) {
        self.state = state
        self.badgeName = badgeName
        self.size = size
    }

    var body: some View {
        VStack {
            // 상태에 따른 뱃지 뷰 표시
            Group {
                switch state {
                    
                // progress 케이스의 경우 CircleProgressView 띄우기
                case .progress(let progress, let icon):
                    CircleProgressView(
                        // 뱃지를 얻기 위한 조건을 달성한 횟수가 n회라면, n/10의 값
                        progress: progress,
                        size: size - 7, // CircleProgressView 코드의 원형Bar 테두리 때문에 이렇게 고쳐야함 왜 7인지는 정확히 모르겠으나(14일줄) 7이어야지 똑같네요
                        icon: icon
                    )
                    
                // locked 케이스의 경우 LockBadgeView 띄우기
                case .locked:
                    LockBadgeView(
                        size: size
                    )
                }
            }
            
            
            Spacer() // 높이 156 고정이니까 Spacer()로 만 주어도 충분 (+CircleProgressView의 정확한 크기가 가늠이 안되어 우선 이렇게)
            
            
            // 뱃지 이름
            Text(badgeName)
                .font(.dsSubhead)
                .foregroundColor(.gray080)
        }
        .frame(width: 130, height: 156)
    }
}



#Preview("뱃지 획득 중 ~ 획득 완료") {
    BadgeView(
        state: .progress(progress: 0.4, icon: Image(systemName: "star.fill")),
        badgeName: "혼밥러"
    )
}

#Preview("뱃지 획득 이전") {
    BadgeView(
        state: .locked,
        badgeName: "기록마스터"
    )
}
