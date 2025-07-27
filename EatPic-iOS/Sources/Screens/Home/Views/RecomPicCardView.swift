//
//  RecomPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct RecomPicCardView: View {
    var body: some View {
        VStack {
            PicCardView(
                profileImage: Image(systemName: "circle.fill"),
                profileID: "아이디",
                time: "오후 6:30",
                onEllipsisTapped: {
                    Button(role: .destructive, action: {
                        print("신고하기")
                    }) {
                        Label("신고하기", systemImage: "exclamationmark.bubble")
                    }
                },
                postImage: Image(systemName: "square.fill"),
                myMemo: "오늘은 샐러드를 먹었습니다~")
        }
    }
}


#Preview {
    RecomPicCardView()
}
