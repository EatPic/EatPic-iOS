//
//  MyBadgeStatusAllView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct MyBadgeStatusAllView: View {
    
    @StateObject private var viewModel = MyBadgeStatusViewModel()
    
    var body: some View {
        VStack {
            Spacer().frame(height: 32)
            
            HStack {
                Text("잇콩님이 획득한 배지 현황")
                    .font(.dsBody)
                    .foregroundColor(Color.gray080)
                
                Spacer().frame(width: 7)
                
                Group {
                    Text(viewModel.getBadgeStatus())
                        .font(.dsTitle3)
                        .foregroundColor(Color.green060)
                    
                    +
                    
                    Text("/\(viewModel.totalBadges)")
                        .font(.dsTitle3)
                        .foregroundColor(Color.gray060)
                }
            }
            
            // 획득 뱃지 현황
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 24
                ) {
                    ForEach(viewModel.badgeItems) { badgeItem in
                        BadgeView(
                            state: badgeItem.state,
                            badgeName: badgeItem.name
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 48)
            }
        }
        .customNavigationBar {
            Text("활동 뱃지")
        } right: {
            EmptyView()
        }
    }
}

#Preview {
    MyBadgeStatusAllView()
}
