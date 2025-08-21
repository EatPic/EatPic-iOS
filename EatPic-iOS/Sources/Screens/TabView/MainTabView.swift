//
//  MainTabView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

struct MainTabView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject private var container: DIContainer
    @State private var mediaPickerProvider: MediaPickerProvider
    
    @State private var selectedTab: TabCase = .home
    @State private var previousTab: TabCase = .home
    @State private var showCamera: Bool = false
    @State private var showPickerDialog = false
    @State private var showPhotosPicker: Bool = false
    
    private let maxImgSelectionCount: Int = 5
    
    init(container: DIContainer) {
        self.mediaPickerProvider = .init(
            mediaPickerService: container.mediaPickerService)
    }
    
    var body: some View {
        NavigationStack(path: $container.router.destinations) {
            renderTabView()
                .navigationDestination(for: NavigationRoute.self) { route in
                    NavigationRoutingView(route: route)
                }
                .confirmationDialog(
                    "기록할 방법을 선택해주세요!",
                    isPresented: $showPickerDialog,
                    titleVisibility: .visible
                ) {
                    Button("앨범에서 선택") {
                        showPhotosPicker = true
                    }
                    
                    Button("카메라로 촬영") {
                        mediaPickerProvider.presentCamera()
                    }
                    
                    Button("취소", role: .cancel) { }
                }
                .photosPicker(
                    isPresented: $showPhotosPicker,
                    selection: $mediaPickerProvider.selections,
                    maxSelectionCount: maxImgSelectionCount,
                    matching: .images
                )
                .onChange(of: selectedTab) { _, new in
                    if new == .writePost {
                        // 탭 전환 무효화 + 다이얼로그만 띄우기
                        selectedTab = previousTab
                        
                        showPickerDialog = true
                    } else {
                        previousTab = new
                        if new == .community {
                            // 커뮤니티 탭 진입 전 선행 프리패치로 체감 지연 최소화
                            Task { @MainActor in
                                let viewModel = container.getCommunityMainVM()
                                await viewModel.refreshFeeds(reset: false)
                            }
                        }
                    }
                }
                // 포그라운드 복귀: 현재 탭이 커뮤니티면 tick 증가 → 커뮤니티 화면에서 .task(id:)가 반응
                .onChange(of: scenePhase) { _, phase in
                    guard phase == .active else { return }
                    if selectedTab == .community {
                        Task { @MainActor in
                            container.bumpForegroundRefresh()
                        }
                    }
                }
                // 앱이 탭 화면에 진입했을 때 최초 1회 activeTab 동기화(안전장치)
                .task {
                    await MainActor.run {
                        container.setActiveTab(selectedTab)
                    }
                }
                .task {
                    mediaPickerProvider.onDidAddImages = { [weak container] newly in
                        container?.router.push(.mealTimeSelection(image: newly))
                        
                        showPickerDialog = false
                        showPhotosPicker = false
                    }
                }
                .onChange(of: mediaPickerProvider.selections) { _, new in
                    mediaPickerProvider.loadImages(from: new)
                    // 갤러리에서 이전에 선택한 이미지를 모두 제거하기 위한 호출
                    mediaPickerProvider.removeAllSelectionsImages()
                }
        }
    }
    
    /// iOS 버전 대응을 위한 탭뷰 함수
    ///
    /// `Tab(value:, content:, label:)`은 iOS 18 이상부터 지원하기 때문에, 버전을 분리하여 대응하였습니다.
    @ViewBuilder
    private func renderTabView() -> some View {
        Group {
            if #available(iOS 18, *) {
                TabView(selection: $selectedTab) {
                    ForEach(TabCase.allCases, id: \.rawValue) { tab in
                        Tab(value: tab) {
                            tabView(tab: tab)
                        } label: {
                            tabLabel(tab)
                        }
                    }
                }
            } else {
                TabView(selection: $selectedTab) {
                    ForEach(TabCase.allCases, id: \.rawValue) { tab in
                        tabView(tab: tab)
                            .tabItem {
                                tabLabel(tab)
                            }
                            .tag(tab)
                    }
                }
            }
        }
        .tint(Color.green060)
    }
    
    /// 탭 레이블 (아이콘 + 텍스트)
    @ViewBuilder
    private func tabLabel(_ tab: TabCase) -> some View {
        VStack(spacing: 8) {
            if tab == .writePost {
                tab.icon
                    .renderingMode(.original)
            } else {
                tab.icon
                    .renderingMode(.template)
                
                Text(tab.rawValue)
                    .foregroundStyle(Color.gray060)
                    .font(Font.dsCaption1)
            }
        }
    }
    
    @ViewBuilder
    private func tabView(tab: TabCase) -> some View {
        TabViewContent(tab: tab)
            .environmentObject(container)
    }
}

#Preview {
    MainTabView(container: .init())
        .environmentObject(DIContainer())
}
