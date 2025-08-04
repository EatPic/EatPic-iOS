//
//  MypageCarView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/3/25.
//

import SwiftUI

struct MyPageCardView: View {
    let iconName: String
    let title: String
    let description: String
    let countText: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(iconName)
                        
                        Text(title)
                            .font(.dsFootnote)
                            .foregroundColor(.gray080)
                    }
                    Text(description)
                        .font(.dsTitle3)
                        .foregroundColor(.black)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text(countText)
                        .foregroundColor(.pink060)
                        .font(.dsHeadline)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 0)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MyPageCardView(
            iconName: "card",
            title: "전체 Pic 카드",
            description: "나의 전체 Pic 카드 확인해보기",
            countText: "0개"
        ) {
            print("전체 카드 클릭")
        }

        MyPageCardView(
            iconName: "bookmark",
            title: "저장한 Pic 카드",
            description: "내가 저장한 Pic 카드 확인해보기",
            countText: "0개"
        ) {
            print("저장 카드 클릭")
        }

        MyPageCardView(
            iconName: "badge",
            title: "활동 배지",
            description: "지금까지 모은 뱃지 확인해보기",
            countText: "0개"
        ) {
            print("배지 클릭")
        }
    }
    .padding()
}
