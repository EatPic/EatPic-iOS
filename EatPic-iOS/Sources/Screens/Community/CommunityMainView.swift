//
//  CommunityMainView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/22/25.
//

import SwiftUI

struct CommunityMainView: View {
    
    @EnvironmentObject private var container: DIContainer
    @State private var selectedUser: CommunityUser = sampleUsers[0]
    
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
    
    // 필터링된 카드 리스트
    private var filteredCards: [PicCard] {
        if selectedUser.nickname == "전체" {
            return sampleCards
        } else {
            return sampleCards.filter { $0.user == selectedUser }
        }
    }
    
    private func userListView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(sampleUsers) { user in
                    VStack(spacing: 16) {
                        ProfileImageView(
                            image: user.profileImage,
                            size: 64,
                            borderColor: user == selectedUser ? .pink050 : .gray040,
                            borderWidth: 3
                        )
                        Text(user.id)
                            .font(.dsSubhead)
                            .foregroundStyle(Color.gray080)
                    }
                    .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
                    .onTapGesture {
                        selectedUser = user
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: 112)
        }
        .scrollIndicators(.hidden)
    }
    
    // 카드 리스트 뷰
    private func cardListView() -> some View {
        LazyVStack(spacing: 32) {
            ForEach (filteredCards) { card in
                PicCardView(
                    profileImage: card.user.profileImage ?? Image(systemName: "person.fill"),
                    profileID: card.user.id,
                    time: card.time,
                    menuContent: {
                        Button(role: .destructive, action: {
                            print("신고하기")
                        }) {
                            Label("신고하기", systemImage: "exclamationmark.bubble")
                        }
                    },
                    postImage: card.image,
                    myMemo: card.memo,
                    onProfileTap: {
                        container.router.push(.userProfile(user: card.user))
                    }
                )
            }
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
