//
//  ExploreSelectedView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/31/25.
//

import SwiftUI

struct ExploreSelectedView: View {
    
    @Bindable private var toastVM = ToastViewModel()
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0), spacing: 9.5),
        GridItem(.flexible(minimum: 0), spacing: 9.5)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 51) {
                selectedPicCardView()
                recommendedFeedView()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .scrollIndicators(.hidden)
        .customCenterNavigationBar(title: {
            Text("탐색")
                .font(.dsTitle2)
        })
    }
    
    private func selectedPicCardView() -> some View {
        // 1. PicCard 객체를 직접 생성합니다.
        let card = PicCard(
            user: CommunityUser(
                id: "itcong",
                nickname: "잇콩", // 닉네임 추가
                imageName: "Community/itcong",
                isCurrentUser: false,
                isFollowed: false
            ),
            time: "오후 12:30",
            image: Image("Community/testImage"),
            memo: "오늘은 샐러드를 먹었습니다~ 계란과 딸기를 많이 넣어 먹었어요~~~~ 다들 좋은 하루 보내세용",
            imageUrl: nil, date: "2025-08-11", meal: "LUNCH", recipe: "레시피 내용...",
            recipeUrl: nil, latitude: nil, longitude: nil, locationText: "서울", hashtags: ["#샐러드"],
            reactionCount: 0, userReaction: nil, commentCount: 0, bookmarked: false
        )
        
        // 2. 생성한 card 객체를 PicCardView의 매개변수로 전달합니다.
        return PicCardView(
            card: card,
            menuContent: {
                Button(role: .destructive, action: {
                    print("신고하기")
                }, label: {
                    Label("신고하기", systemImage: "exclamationmark.bubble")
                })
            },
            onProfileTap: {
                print("프로필로 이동")
            },
            toastVM: toastVM,
            onItemAction: nil // 필요에 따라 구현하거나 nil로 둡니다.
        )
    }
    
    private func recommendedFeedView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("더 찾아보기")
                .font(.dsTitle3)
                .foregroundStyle(.black)
            
            LazyVGrid(columns: columns, spacing: 9, content: {
                ForEach(0..<9) { _ in
                    explorePicCard()
                }
            })
        }
    }
    
    private func explorePicCard() -> some View {
        GeometryReader { geometry in
            ZStack {
                Image("Explore/testImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack(spacing: 4) {
                    Image("icon_comment")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("99+")
                        .font(.dsBold13)
                        .foregroundStyle(Color.white)
                    Image("icon_emotion")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("10")
                        .font(.dsBold13)
                        .foregroundStyle(Color.white)
                }
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    ExploreSelectedView()
}
