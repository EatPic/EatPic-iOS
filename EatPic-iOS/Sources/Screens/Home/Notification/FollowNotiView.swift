//
//  FollowNotiView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

/// - Parameters:
///   - friendNickNname: 알림을 일으킨 사람의 닉네임
///   - notiTime: 알림 온 시간
///   - state: 알림 바 클릭 상태
///   - onFollowTap: 팔로우 버튼 클릭 시 실행할 액션
struct FollowNotiView: View {
    let friendNickname: String
    let notiTime: String
    let state: NotiState
    let onFollowTap: () -> Void

    var body: some View {
        HStack {
            // 프로필 사진
            ProfileImageView(size: 47)
            
            Spacer().frame(width: 16)
            
            // 알림 메시지
            VStack(alignment: .leading) {
                Text("\(friendNickname) 님이 회원님을 팔로우합니다.")
                    .foregroundColor(.gray080)
                    .font(.dsFootnote)
                
                Text("\(notiTime) 전")
                    .foregroundColor(.gray060)
                    .font(.dsFootnote)
            }
            
            Spacer()
            
            // 팔로우 버튼
            Button(action: onFollowTap, label: {
                Text("팔로잉")
                    .foregroundColor(state.followButtonTextColor)
                    .font(.dsBold15)
                    .frame(width: 64, height: 28)
            })
            .background(state.followButtonColor)
            .cornerRadius(5)
            
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(state.backgroundColor)
    }
}

#Preview ("알림 클릭 전") {
    FollowNotiView(friendNickname: "aaa", notiTime: "23시간", state: .unclicked, onFollowTap: { print("팔로우") })
}

#Preview ("알림 클릭 후") {
    FollowNotiView(friendNickname: "aaa", notiTime: "23시간", state: .clicked, onFollowTap: { print("팔로우") })
}
