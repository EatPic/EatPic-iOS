//
//  MyBadgeStatusAllView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct MyBadgeStatusAllView: View {
    
    @ObservedObject private var viewModel: MyBadgeStatusViewModel
    @State private var badgeDetailViewModel: BadgeDetailViewModel
    @State private var selectedBadge: MyBadgeStatusViewModel.BadgeItem?
    @State private var showingBadgeModal = false
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
        self.badgeDetailViewModel = .init(container: container)
    }
    
    var body: some View {
        ZStack {
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
            
            // 배지 모달 - 전체 화면 위에 표시
            if showingBadgeModal, let badge = selectedBadge {
                BadgeProgressModalView(
                    badgeType: badgeDetailViewModel.createBadgeModalType(for: badge),
                    closeBtnAction: {
                        showingBadgeModal = false
                        selectedBadge = nil
                    },
                    badgeSize: 130,
                    badgeTitle: badge.name,
                    badgeDescription: badgeDetailViewModel.description(
                        for: badge.userBadgeId,
                        fallbackName: badge.name)
                )
            }
        }
    }
    
    // MARK: 상단 타이틀 바
    private var titleBar: some View {
        HStack {
            Text("잇콩님이 획득한 배지 현황")
                .font(.dsBody)
                .foregroundStyle(Color.gray080)
            
            Spacer().frame(width: 7)
            
            Group {
                Text(viewModel.getBadgeStatus())
                    .font(.dsTitle3)
                    .foregroundStyle(Color.green060)
                
                +
                
                Text("/\(viewModel.totalBadges)")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.gray060)
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
                    // 배지 탭 
                    .onTapGesture {
                        selectedBadge = badgeItem
                        showingBadgeModal = true
                    }
                }
            }
            .padding(.horizontal, 35)
            .padding(.top, 32)
            .padding(.bottom, 48)
        }
    }
}

#Preview {
    MyBadgeStatusAllView(container: .init())
}
