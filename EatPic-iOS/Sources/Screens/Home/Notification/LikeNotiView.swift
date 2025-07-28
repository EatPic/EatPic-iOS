//
//  LikeNotiView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

/// - Parameters:
///   - friendNickNname: 알림을 일으킨 사람의 닉네임
///   - notiTime: 알림 온 시간
///   - state: 알림 바 클릭 상태
///   - postImageName: 게시글 이미지 이름 (선택사항)
struct LikeNotiView: View {
    let friendNickname: String
    let notiTime: String
    let state: NotiState
    let postImageName: String?

    var body: some View {
        HStack {
            // 프로필 사진
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
            
            // 게시글 사진
            if let postImageName = postImageName {
                Image(postImageName)
                    .resizable()
                    .frame(width: 47, height: 47)
                    .cornerRadius(4)
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray020)
                    .frame(width: 47, height: 47)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(state.backgroundColor)
    }
}

#Preview("알림 클릭 전") {
    LikeNotiView(friendNickname: "absdfsdfcd", notiTime: "21시간", state: .unclicked, postImageName: "sample_post_1")
}

#Preview("알림 클릭 후") {
    LikeNotiView(friendNickname: "absdfsdfcd", notiTime: "21시간", state: .clicked, postImageName: "sample_post_1")
}
