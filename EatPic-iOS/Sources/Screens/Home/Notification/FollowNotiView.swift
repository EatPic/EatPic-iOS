//
//  FollowNotiView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct FollowNotiView: View {
    let friendNickname: String
    let notiTime: String
    let state: NotiState

    var body: some View {
        HStack {
            // 프로필 사진
//            Circle()
//                .frame(width: 47, height: 47)
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
            Button(action: {
                print("팔로우 버튼 누르기")
            }, label: {
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
    FollowNotiView(friendNickname: "aaa", notiTime: "23시간", state: .unclicked)
}

#Preview ("알림 클릭 후") {
    FollowNotiView(friendNickname: "aaa", notiTime: "23시간", state: .clicked)
}

