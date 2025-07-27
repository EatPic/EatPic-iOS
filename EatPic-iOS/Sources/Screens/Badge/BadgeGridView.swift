//
//  BadgeGridView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct BadgeGridView: View {
    // MARK: - Property
    @State private var viewModel = BadgeGridViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(viewModel.userNickname)님이 획득한 배지 현황")
                        .font(.dsTitle2)
                        .foregroundColor(.gray080)
                    
                    Spacer()
                    
                    Text(viewModel.progressText)
                        .font(.dsTitle2)
                        .foregroundColor(.green060)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 24)
            
            // 뱃지 그리드
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 24
                ) {
                    ForEach(viewModel.badges, id: \.id) { badge in
                        BadgeView(
                            state: badge.badgeState,
                            badgeName: badge.name,
                            size: 130
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .background(Color.white)
    }
}

#Preview {
    BadgeGridView()
} 