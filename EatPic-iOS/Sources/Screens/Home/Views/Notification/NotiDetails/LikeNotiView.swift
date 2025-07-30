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
    @State var noticlickstate: NotiClickState
    @State var followstate: NotiFollowState

    init(
        friendNickname: String,
        notiTime: String,
        noticlickstate: NotiClickState = .unclicked,
        followstate: NotiFollowState = .unfollow
    ) {
        self.friendNickname = friendNickname
        self.notiTime = notiTime
        self._noticlickstate = State(initialValue: noticlickstate) // 기본값 unclicked
        self._followstate = State(initialValue: followstate) // 기본값 unfollow
    }
    
    var body: some View {
        HStack {
            ProfileImageView(size: 47)
            
            Spacer().frame(width: 16)
            
            notiMessage
            
            Spacer()
            
            // FIXME: 게시글 사진.. ( << 어케 불러옴?)
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 47, height: 47)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(noticlickstate.backgroundColor)
        .onTapGesture {
            if noticlickstate == .unclicked {
                print("알림 클릭")
                noticlickstate = .clicked
            }
        }
    }
    
    // MARK: 알림 메시지
    private var notiMessage: some View {
        VStack(alignment: .leading) {
            Text("\(friendNickname) 님이 회원님의 식사 기록을 좋아합니다")
                .foregroundColor(.gray080)
                .font(.dsFootnote)
            
            Text("\(notiTime) 전")
                .foregroundColor(.gray060)
                .font(.dsFootnote)
        }
    }
}

#Preview("알림 클릭 전") {
    LikeNotiView(friendNickname: "absdfsdfcd",
                 notiTime: "21시간")
}

#Preview("알림 클릭 후") {
    LikeNotiView(friendNickname: "absdfsdfcd",
                 notiTime: "21시간")
}
