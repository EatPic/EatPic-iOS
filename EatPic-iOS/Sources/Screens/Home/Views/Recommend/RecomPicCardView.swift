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
    private let sampleCard = PicCard(
        user: CommunityUser(
            id: "아이디", nickname: "아이디",
            imageName: nil, isCurrentUser: false,
            isFollowed: false),
        time: "오후 6:30",
        image: Image(systemName: "square.fill"),
        memo: "오늘은 샐러드를 먹었습니다~",
        imageUrl: nil, date: "2025-07-01", meal: "LUNCH", recipe: "레시피 설명...",
        recipeUrl: nil, latitude: nil, longitude: nil, locationText: "캐나다라마바사", hashtags: ["#점심"],
        reactionCount: 0, userReaction: nil, commentCount: 0, bookmarked: false
    )
    
    var body: some View {
        VStack {
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
