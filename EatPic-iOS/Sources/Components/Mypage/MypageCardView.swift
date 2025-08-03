//
//  MypageCarView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/3/25.
//

import SwiftUI

import SwiftUI

struct MypageCardView: View {
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
                        Image(systemName: iconName)
                            .foregroundStyle(Color.pink060)
                        
                        Text(title)
                            .font(.dsFootnote)
                            .foregroundColor(.gray080)
                    }
                    Text(description)
                        .font(.headline)
                        .foregroundColor(.black)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text(countText)
                        .foregroundColor(.pink060)
                        .font(.headline)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MypageCardView(
            iconName: "square.grid.2x2.fill",
            title: "전체 Pic 카드",
            description: "나의 전체 Pic 카드 확인해보기",
            countText: "0개"
        ) {
            print("전체 카드 클릭")
        }

        MypageCardView(
            iconName: "bookmark.fill",
            title: "저장한 Pic 카드",
            description: "내가 저장한 Pic 카드 확인해보기",
            countText: "0개"
        ) {
            print("저장 카드 클릭")
        }

        MypageCardView(
            iconName: "rosette",
            title: "활동 배지",
            description: "지금까지 모은 뱃지 확인해보기",
            countText: "0개"
        ) {
            print("배지 클릭")
        }
    }
    .padding()
}
