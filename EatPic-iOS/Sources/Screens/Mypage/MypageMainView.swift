//
//  MypageMainView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/3/25.
//

import SwiftUI

struct MypageMainView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            topSetupButton
            Text("mypage")
            Spacer()
        }
    }
    
    // MARK: - TopContentes(상단 콘텐츠)
    
    /// 상단 설정 버튼
    private var topSetupButton: some View {
        HStack {
            Spacer()
            Button(
                action: {print("설정클릭")},
                label: {
                    Image(systemName: "gearshape.fill")
                        .frame(width: 24, height: 24)
                })
            .foregroundStyle(Color.black)
        }
    }
    
    // MARK: - Middle Contents(중앙 콘텐츠)
    
    /// 중앙 컨텐츠
    private var middleContents: some View {
        VStack(alignment: .center, spacing: 16) {
            middleProfileImage
            middleNickname
            middleIntroduction
            middleFollowButton
        }
    }
    
    /// 중앙 프로필 이미지
    private var middleProfileImage: some View {
        Image("itcong")
            .frame(width: 100, height: 100)
    }
    
    /// 마이페이지 프로필 닉네임 및 아이디
    private var middleNickname: some View {
        (
        Text("잇콩\n")
            .font(.dsTitle3)
        + Text("itcong")
            .font(.dsSubhead)
            .foregroundStyle(Color.gray040)
        )
        .multilineTextAlignment(.center)
    }
    
    /// 마이페이지 프로필 사용자 한줄소개 텍스트
    private var middleIntroduction: some View {
        Text("안녕하세요 밥 먹는거 좋아하는 잇콩입니다")
            .font(.dsCaption1)
    }
    
    /// 마이페이지 팔로워 및 팔로워 버튼
    private var middleFollowButton: some View {
        HStack {
            Spacer()
            Button {
                print("팔로워 선택")
            } label: {
                (
                Text("0\n")
                + Text("팔로워")
                )
                .multilineTextAlignment(.center)
            }

            Spacer()
            Button {
                print("팔로잉 선택")
            } label: {
                (
                Text("0\n")
                + Text("팔로잉")
                )
                .multilineTextAlignment(.center)
            }

            Spacer()
        }
    }
}

#Preview {
    MypageMainView()
}
