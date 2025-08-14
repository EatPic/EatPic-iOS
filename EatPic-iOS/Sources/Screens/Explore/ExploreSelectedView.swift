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
        // 더미 User 데이터
        let dummyFeedUser = FeedUser(
            userId: 98765,
            nickname: "원주연",
            profileImageUrl: "https://example.com/images/profile_ju_yeon.jpg"
        )
        let dummyUser = CommunityUser(from: dummyFeedUser)
        // 더미 Feed 데이터
        let dummyFeed = Feed(
            cardId: 101,
            imageUrl: "https://example.com/images/pasta_feed_image.jpg",
            date: [2025, 7, 1],
                time: [14, 0, 0, 0],
            meal: .LUNCH,
            memo: "오늘 점심으로 먹은 파스타! 정말 맛있었어요! 😋",
            recipe: "봉골레 파스타",
            recipeUrl: "https://example.com/recipes/vongole_pasta",
            latitude: 37.5665,
            longitude: 126.9780,
            locationText: "서울 종로구",
            hashtags: ["#파스타", "#맛스타그램", "#봉골레"],
            user: dummyFeedUser,
            reactionCount: 15,
            userReaction: "TASTY",
            commentCount: 3,
            bookmarked: false
        )
        let card = PicCard(from: dummyFeed)
        
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
