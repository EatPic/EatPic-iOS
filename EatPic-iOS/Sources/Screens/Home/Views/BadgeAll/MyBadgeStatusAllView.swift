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
            
            titleBar
            
            badgeScroll
        }
        .customNavigationBar {
            Text("활동 뱃지")
        } right: {
            EmptyView()
        }
    }
    
    // MARK: 상단 타이틀 바
    // FIXME: [25. 08. 01] nickname 잇콩 : 서버에서 받아온 이름? - 비엔/이은정
    // FIXME: [25. 08. 01] 획득 뱃지 개수: 상태 관리 필요 (현재 뷰모델에서는 acquiredBadges - 비엔/이은정
    private var titleBar: some View {
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
    }
    
    // MARK: 획득 뱃지 현황
    private var badgeScroll: some View {
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
            .padding(.horizontal, 35)
            .padding(.top, 32)
            .padding(.bottom, 48)
        }
    }
}

#Preview {
    MyBadgeStatusAllView()
}
