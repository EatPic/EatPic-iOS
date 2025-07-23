//
//  LikeNotiView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct LikeNotiView: View {
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
            
            // 알림 문구
            (
                Text("\(friendNickname) 님이 회원님의 식사 기록에 댓글을 남겼습니다. ")
                    .foregroundColor(.gray080)
                    .font(.dsFootnote)
                +
                Text("\(notiTime) 전")
                    .foregroundColor(.gray060)
                    .font(.dsFootnote)
            )
            
            Spacer()
            
            // 게시글 사진.. ( << 어케 불러옴?)
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 47, height: 47)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(state.backgroundColor)
    }
}

#Preview("알림 클릭 전") {
    LikeNotiView(friendNickname: "absdfsdfcd", notiTime: "21시간", state: .unclicked)
}

#Preview("알림 클릭 후") {
    LikeNotiView(friendNickname: "absdfsdfcd", notiTime: "21시간", state: .clicked)
}
