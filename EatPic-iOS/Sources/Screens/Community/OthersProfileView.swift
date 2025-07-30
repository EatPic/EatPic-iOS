//
//  OthersProfileView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/24/25.
//

import SwiftUI

/**
 # OthersProfileView
 - 다른 유저의 프로필을 보여주는 화면입니다.
 - 해당 유저의 프로필 이미지, 닉네임, 아이디, 소개글, 팔로워/팔로잉/Pic 카드 수 등을 포함합니다.
 - 유저의 피드(Post) 이미지들을 그리드 형식으로 나열하여 보여줍니다.
 - 팔로우/언팔로우 버튼을 통해 상태를 토글할 수 있습니다.
 - 우측 상단 메뉴 버튼을 통해 '차단하기', '신고하기' 기능을 제공할 수 있습니다 (현재 액션 미구현).

 ## 주요 UI 구성
 - `ScrollView` 내에 전체 UI를 감싸며 스크롤 가능
 - `userProfileView()` : 프로필 관련 정보와 소개글, 통계 정보 등 표시
 - `PrimaryButton` : 팔로우/언팔로우 상태에 따라 색상과 텍스트 변경
 - `userFeedView()` : 피드 이미지(사각형 placeholder)를 3열 그리드로 구성
 - `customNavigationBar(title:right:)` : 우측 상단에 메뉴 버튼 (ellipsis)

 ## 상태 변수
 - `@State private var isFollowed` : 현재 팔로우 상태를 나타내며 버튼의 UI 및 동작에 반영됩니다.

 ## 커스텀 뷰 사용
 - `PrimaryButton` : 재사용 가능한 버튼 컴포넌트
 - `ProfileImageView` : 프로필 이미지를 원형 등으로 표현하는 뷰
 - `.customNavigationBar` : 사용자 정의 네비게이션 바 Modifier

 ## 추후 확장
 - 실제 유저 데이터 연결 (닉네임, 아이디, 소개글, 팔로워 수 등)
 - 피드 이미지와 관련된 동작(탭 시 상세 보기 등)
 - 차단/신고 기능 구현
 */

struct OthersProfileView: View {
    let user: CommunityUser
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0), spacing: 4),
        GridItem(.flexible(minimum: 0), spacing: 4),
        GridItem(.flexible(minimum: 0), spacing: 4)
    ]
    
    @EnvironmentObject private var container: DIContainer
    @State private var isFollowed: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                userProfileView()
                Spacer().frame(height: 16)
                
                if isFollowed {
                    PrimaryButton(
                        color: .gray030,
                        text: "팔로잉",
                        font: .dsBold15,
                        textColor: .gray050,
                        width: 109,
                        height: 28,
                        cornerRadius: 6,
                        action: {
                            isFollowed.toggle()
                            print("unfollow")
                        })
                } else {
                    PrimaryButton(
                        color: .green060,
                        text: "팔로우",
                        font: .dsBold15,
                        textColor: .white,
                        width: 109,
                        height: 28,
                        cornerRadius: 6,
                        action: {
                            isFollowed.toggle()
                            print("follow")
                        })
                }
                Spacer().frame(height: 19)
                
                userFeedView()
            }
            .customNavigationBar(title: {
                Text("")
            }, right: {
                Menu {
                    Button(role: .destructive) { } label: {
                        Label("차단하기", systemImage: "hand.raised.slash")
                    }
                    Button(role: .destructive) {} label: {
                        Label("신고하기", systemImage: "info.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.black)
                }
            })
        }
        .scrollIndicators(.hidden)
    }
    
    private func userProfileView() -> some View {
        VStack {
            Spacer().frame(height: 8)
            ProfileImageView(image: user.profileImage ?? Image(systemName: "person.fill"),
                             size: 100)
        
            Spacer().frame(height: 16)
            
            Text(user.nickname)
                .font(.dsTitle3)
                .foregroundStyle(Color.gray080)
            Text("@"+user.id)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray060)
            Spacer().frame(height: 18)
            
            Text("소개글입니다ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ")
                .font(.dsCaption1)
                .foregroundStyle(Color.gray060)
                .padding(.horizontal, 16)
            Spacer().frame(height: 16)
            
            followerCountView()
            Spacer().frame(height: 10)
        }
    }
    
    private func followerCountView() -> some View {
        HStack(spacing: 80) {
            VStack {
                Text("0")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("Pic 카드")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
            
            VStack {
                Text("0")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("팔로워")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
            .onTapGesture {
                container.router.push(.followList(selected: .followers))
            }
            
            VStack {
                Text("0")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("팔로잉")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
            .onTapGesture {
                container.router.push(.followList(selected: .followings))
            }
        }
    }
    
    private func userFeedView() -> some View {
        LazyVGrid(columns: columns, spacing: 4, content: {
            ForEach(0..<10) { index in
                Rectangle()
                    .fill(Color.gray030)
                    .aspectRatio(1, contentMode: .fit)
            }
        })
        .padding(.horizontal, 16)
    }
}

#Preview {
    OthersProfileView(user: CommunityUser(
            id: "hong",
            nickname: "홍길동",
            imageName: nil,
            isCurrentUser: true
        ))
}
