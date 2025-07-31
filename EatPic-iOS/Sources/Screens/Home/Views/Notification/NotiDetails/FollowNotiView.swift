//
//  FollowNotiView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct FollowNotiView: View {
    let friendNickname: String // FIXME: [25.07.30] 이거 나중에 닉네임 UUID? 로 받아오는? 주연언니 코드 보기 – 비엔/이은정
    let notiTime: String // FIXME: [25.07.30] notiTime 서버에서 받아오게 타입 고치기? 상태관리? – 비엔/이은정
    
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
            // 프로필 사진
            ProfileImageView(size: 47)
            
            Spacer().frame(width: 16)
            
            // 알림 메시지
            notiMessage
            
            Spacer()
            
            // 팔로우 버튼
            followButton
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(noticlickstate.backgroundColor)
        .onTapGesture {
            // FollowNotiView 클릭 시 (한 번만 clicked로 변경)
            if noticlickstate == .unclicked {
                print("알림 클릭")
                noticlickstate = .clicked
            }
        }
    }
    
    // MARK: 알림 메시지
    private var notiMessage: some View {
        VStack(alignment: .leading) {
            Text("\(friendNickname) 님이 회원님을 팔로우합니다.")
                .foregroundColor(.gray080)
                .font(.dsFootnote)
            
            Text("\(notiTime) 전")
                .foregroundColor(.gray060)
                .font(.dsFootnote)
        }
    }
    
    // MARK: 팔로우 버튼
    private var followButton: some View {
        Button(action: {
            // TODO: 추후 팔로우/언팔로우 정보? 받? 액션?????
            if followstate == .unfollow {
                print("팔로우합니당")
            } else {
                print("언팔로우입니당")
            }
            // 상태 토글
            followstate = (followstate == .unfollow) ? .follow : .unfollow
        }, label: {
            Text(followstate == .unfollow ? "팔로우" : "팔로잉")
                .foregroundColor(followstate.followButtonTextColor)
                .font(.dsBold15)
                .frame(width: 64, height: 28)
        })
        .background(followstate.followButtonColor)
        .cornerRadius(5)
    }
}

#Preview ("알림 클릭 전") {
    FollowNotiView(friendNickname: "aaa",
                   notiTime: "23시간")
}
