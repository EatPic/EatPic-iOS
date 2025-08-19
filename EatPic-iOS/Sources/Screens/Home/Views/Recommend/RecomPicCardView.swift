//
//  RecomPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

// FIXME: [25.07.30] 추천 픽카드 내용을 Model, ViewModel 공유? - 비엔/이은정
struct RecomPicCardView: View {
    @Bindable private var toastVM = ToastViewModel() // 북마크 토스트메세지를 위해 추가했습니다 !!! (원주연)
    
    // PicCardView의 요구사항에 맞게 PicCard 객체를 생성
    // FIXME: 실제 데이터로 교체해야 합니다.(원주연)
    var body: some View {
        VStack {
            // 더미 User 데이터
            let dummyFeedUser = FeedUser(
                userId: 98765,
                nameId: "wonjy0307",
                nickname: "원주연",
                profileImageUrl: "https://example.com/images/profile_ju_yeon.jpg"
            )
            let dummyUser = dummyFeedUser.toCommunityUser()
            // 더미 Feed 데이터
            let dummyFeed = Feed(
                cardId: 101,
                imageUrl: "https://example.com/images/pasta_feed_image.jpg",
                datetime: "2025-07-01 15:10:00",
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
            let sampleCard = dummyFeed.toPicCard()

            PicCardView(
                card: sampleCard, // ✅ 수정된 부분: card 객체 하나만 전달
                menuContent: {
                    Button(role: .destructive, action: {
                        print("신고하기")
                    }, label: {
                        Label("신고하기", systemImage: "exclamationmark.bubble")
                    })
                },
                onProfileTap: nil, // ✅ 수정된 부분: 필요 없는 경우 nil 전달
                toastVM: toastVM,
                onItemAction: nil // ✅ 수정된 부분: 필요 없는 경우 nil 전달
            )
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .customNavigationBar {
            Text("Pic 카드")
                .font(.dsTitle2)
                .foregroundStyle(Color.gray080)
        } right: {
            EmptyView()
        }
    }
}

#Preview {
    RecomPicCardView()
}
