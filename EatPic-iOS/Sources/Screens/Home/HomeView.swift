//
//  MainHomeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/22/25.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - ProPerty
    
    @EnvironmentObject private var container: DIContainer
    @StateObject private var badgeViewModel = MyBadgeStatusViewModel()
    @State private var showingBadgeModal = false
    @State private var selectedBadge: BadgeItem?
    
    /// 사용자 환영인사 호출 API
    @State private var greetingViewModel: HomeGreetingViewModel
    
    // MARK: - Init
    
    init(container: DIContainer) {
        self.greetingViewModel = .init(container: container)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Spacer().frame(height: 40)
                    
                    topBar
                    
                    MealStatusView()
                    
                    RecomPicCardHomeView()
                    
                    MyBadgeStatusHomeView(
                    selectedBadge: $selectedBadge,
                    showingBadgeModal: $showingBadgeModal
                )
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .background(Color.gray030.ignoresSafeArea())
            
            // 배지 모달
            if showingBadgeModal, let badge = selectedBadge {
                BadgeProgressModalView(
                    badgeType: badgeViewModel.createBadgeModalType(for: badge),
                    closeBtnAction: {
                        showingBadgeModal = false
                        selectedBadge = nil
                    },
                    badgeSize: 130,
                    badgeTitle: badge.name,
                    badgeDescription: badgeViewModel.getBadgeDescription(for: badge.name)
                )
            }
        } //:ZStack
        .task { // 뷰 진입시 API 호출
            await greetingViewModel.fetchGreetingUser()
        }
    }
    
    private var topBar: some View {
        HStack(alignment: .top) {
            if let greet = greetingViewModel.greetingResponse {
                (
                    Text("안녕하세요. ").font(.dsTitle2)
                    + Text(greet.result.nickname).font(.dsTitle2).bold()
                    + Text("님\n").font(.dsTitle2)
                    + Text(greet.result.message).font(.dsTitle2)
                )
                .kerning(-0.44)
            } else {
                (
                    Text("안녕하세요. ").font(.dsTitle2)
                    + Text("회원").font(.dsTitle2).bold()
                    + Text("님\n").font(.dsTitle2)
                    + Text("오늘도 Pic 카드를 기록해볼까요?").font(.dsTitle2)
                )
                .kerning(-0.44)
            }
            
            Spacer()
            
            Button {
                container.router.push(.calendar)
            } label: {
                Image("Home/btn_home_calender")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Spacer().frame(width: 16)
            
            Button {
                print("알림으로 이동")
                container.router.push(.notification)
            } label: {
                Image("Home/btn_home_notification")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    HomeView(container: .init())
}
