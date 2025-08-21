import SwiftUI

struct MyBadgeStatusAllView: View {

    @EnvironmentObject private var container: DIContainer

    // 이 화면에서 생성/소유하므로 StateObject 권장
    @StateObject private var viewModel: MyBadgeStatusViewModel
    @State private var badgeDetailViewModel: BadgeDetailViewModel

    @State private var selectedBadge: MyBadgeStatusViewModel.BadgeItem?
    @State private var showingBadgeModal = false

    // MARK: - Init
    init(container: DIContainer) {
        _viewModel = StateObject(wrappedValue: .init(container: container))
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

            // === 여기: 커스텀 모달 오버레이 ===
            if showingBadgeModal, let badge = selectedBadge {
                // 배경 딤 (터치로 닫기 원하면 onTapGesture 추가)
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingBadgeModal = false
                        selectedBadge = nil
                    }

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
                        fallbackName: badge.name
                    ),
                    progressOverride: badgeDetailViewModel.values(for: badge.userBadgeId)
                )
                // 설명/현재값 지연 로드
                .task(id: badge.userBadgeId) {
                    await badgeDetailViewModel.fetchDescription(userBadgeId: badge.userBadgeId)
                }
            }
        }
        .task { await viewModel.fetchBadgeList() }
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
                Text("/10")
                    .font(.dsTitle2)
                    .foregroundStyle(Color.gray060)
            }
        }
    }

    // MARK: 획득 뱃지 현황
    private var badgeScroll: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                      spacing: 24) {
                ForEach(viewModel.badgeItems) { badgeItem in
                    BadgeView(
                        state: badgeItem.state,
                        badgeName: badgeItem.name
                    )
                    .onTapGesture {
                        selectedBadge = badgeItem
                        showingBadgeModal = true   // ← 이 줄 꼭 필요!
                    }
                }
            }
            .padding(.horizontal, 35)
            .padding(.top, 32)
            .padding(.bottom, 48)
        }
        // 모달 떠 있을 때 스크롤 막고 싶으면:
        // .allowsHitTesting(!showingBadgeModal)
    }
}

#Preview {
    MyBadgeStatusAllView(container: .init())
        .environmentObject(DIContainer()) // 프리뷰용
}
