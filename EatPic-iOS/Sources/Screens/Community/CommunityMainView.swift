//
//  CommunityMainView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/22/25.
//

import SwiftUI

struct CommunityMainView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                userListView()
                cardListView()
                lastContentView()
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private func userListView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                VStack(spacing: 16) {
                    ProfileImageView(
                        image: Image("Community/grid_selected"),
                        size: 64,
                        borderColor: .pink050,
                        borderWidth: 3
                    )
                    Text("전체")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray080)
                }
                .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
                VStack(spacing: 16) {
                    ProfileImageView(
                        size: 64,
                        borderColor: .gray040,
                        borderWidth: 3
                    )
                    Text("나")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray080)
                }
                .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
                VStack(spacing: 16) {
                    ProfileImageView(
                        size: 64,
                        borderColor: .gray040,
                        borderWidth: 3
                    )
                    Text("아이디")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray080)
                }
                .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
                VStack(spacing: 16) {
                    ProfileImageView(
                        size: 64,
                        borderColor: .gray040,
                        borderWidth: 3
                    )
                    Text("아이디")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray080)
                }
                .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
                VStack(spacing: 16) {
                    ProfileImageView(
                        size: 64,
                        borderColor: .gray040,
                        borderWidth: 3
                    )
                    Text("아이디")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray080)
                }
                .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: 112)
        }
        .scrollIndicators(.hidden)
    }
    
    private func cardListView() -> some View {
        LazyVStack(spacing: 32) {
            PicCardView(
                profileImage: Image(systemName: "circle.fill"),
                profileID: "아이디",
                time: "오후 6:30",
                menuContent: {
                    Button(role: .destructive, action: {
                        print("신고하기")
                    }) {
                        Label("신고하기", systemImage: "exclamationmark.bubble")
                    }
                },
                postImage: Image("Community/testImage"),
                myMemo: "오늘은 샐러드를 먹었습니다~")
            
            PicCardView(
                profileImage: Image(systemName: "circle.fill"),
                profileID: "아이디",
                time: "오후 6:30",
                menuContent: {
                    Button(role: .destructive, action: {
                        print("신고하기")
                    }) {
                        Label("신고하기", systemImage: "exclamationmark.bubble")
                    }
                },
                postImage: Image("Community/testImage"),
                myMemo: "오늘은 샐러드를 먹었습니다~")
        }
        .padding(.horizontal, 16)
    }
    
    private func lastContentView() -> some View {
        VStack {
            Spacer().frame(height: 8)
            
            Text("👏🏻")
                .font(.dsLargeTitle)
            
            Spacer().frame(height: 19)
            
            Text("7일 간의 Pic카드를 모두 다 보셨군요!")
                .font(.dsBold15)
            
            Spacer().frame(height: 8)
            
            Text("내일도 잇픽에서 잇친들의 Pic카드를 확인해보세요.")
                .font(.dsFootnote)
            
            Spacer()
        }
        .frame(height: 157)
    }
}

#Preview {
    CommunityMainView()
}
