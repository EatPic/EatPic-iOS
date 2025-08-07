//
//  RecomPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

// FIXME: [25.07.30] 추천 픽카드 내용을 Model, ViewModel 공유? - 비엔/이은정
struct RecomPicCardView: View {
    var body: some View {
        VStack {
            PicCardView(
                profileImage: Image(systemName: "circle.fill"),
                profileID: "아이디",
                time: "오후 6:30",
                menuContent: {
                    Button(role: .destructive, action: {
                        print("신고하기")
                    }, label: {
                            Label("신고하기", systemImage: "exclamationmark.bubble")
                    })
                },
                postImage: Image(systemName: "square.fill"),
                myMemo: "오늘은 샐러드를 먹었습니다~"
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
