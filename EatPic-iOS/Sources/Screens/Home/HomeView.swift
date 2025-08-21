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
    @StateObject private var badgeViewModel: MyBadgeStatusViewModel
    @State private var badgeDetailViewModel: BadgeDetailViewModel
    @State private var showingBadgeModal = false
    @State private var selectedBadge: MyBadgeStatusViewModel.BadgeItem?
    
    /// 사용자 환영인사 호출 API
    @State private var greetingViewModel: HomeGreetingViewModel
    
    // 카메라 모달 표시 여부
        @State private var showRecordModal = false
    
    // MARK: - Init
    
    init(container: DIContainer) {
        self.greetingViewModel = .init(container: container)
        _badgeViewModel = StateObject(
            wrappedValue: MyBadgeStatusViewModel(container: container))
        self.badgeDetailViewModel = .init(container: container)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Spacer().frame(height: 40)
                    
                    topBar
                    
                    // EmptyMealView에서 “추가하기” 누르면 이 모달 띄우게끔 클로저 전달
                    MealStatusView(container: container, onTapEmptyMeal: {
                        showRecordModal = true
                    })
                    
                    RecomPicCardHomeView(container: container)
                    
                    MyBadgeStatusHomeView(
                        viewModel: badgeViewModel,
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
                    badgeType: badgeDetailViewModel
                        .createBadgeModalType(for: badge),
                    closeBtnAction: {
                        showingBadgeModal = false
                        selectedBadge = nil
                    },
                    badgeSize: 130,
                    badgeTitle: badge.name,
                    badgeDescription: badgeDetailViewModel.description(
                        for: badge.userBadgeId,
                        fallbackName: badge.name),
                    progressOverride: badgeDetailViewModel.values(for: badge.userBadgeId)
                )
                // 모달 표시 시 설명 지연 로드
                .task(id: badge.userBadgeId) {
                    await badgeDetailViewModel
                        .fetchDescription(userBadgeId: badge.userBadgeId)
                }
            }
            
            // 카메라/앨범 모달
            if showRecordModal {
                Color.black.opacity(0.45).ignoresSafeArea().onTapGesture { showRecordModal = false }
                CameraRecordModalView(
                    container: container,
                    onClose: { showRecordModal = false },
                    onPickedImages: { images in
                        // 기존 흐름과 동일: 선택된 이미지로 다음 화면 이동
                        container.router.push(.mealTimeSelection(image: images))
                    }
                )
            }
        }
        .task { // 뷰 진입시 API 호출
            await greetingViewModel.fetchGreetingUser()
            await badgeViewModel.fetchBadgeList()
        }
    }
    
    private var topBar: some View {
        HStack(alignment: .top) {
            if let greet = greetingViewModel.greetingResponse {
                (
                    Text("안녕하세요. ").font(.dsTitle3)
                    + Text(greet.result.nickname).font(.dsTitle3)
                    + Text("님\n").font(.dsTitle3)
                    + Text(greet.result.message).font(.dsTitle3)
                )
                .kerning(-0.44)
            } else {
                (
                    Text("안녕하세요. ").font(.dsTitle3)
                    + Text("회원").font(.dsTitle3).bold()
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
