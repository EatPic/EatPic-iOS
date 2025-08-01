//
//  MainTabView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject private var container: DIContainer
    @State private var selectedTab: TabCase = .home
    
    var body: some View {
        NavigationStack(path: $container.router.destinations) {
            renderTabView()
                .navigationDestination(for: NavigationRoute.self) { route in
                    NavigationRoutingView(route: route)
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
    MainTabView()
        .environmentObject(DIContainer())
}
