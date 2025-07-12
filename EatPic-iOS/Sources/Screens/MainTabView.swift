//
//  MainTabView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

enum TabCase: String, CaseIterable {
    case home = "home"
    case community = "community"
    case writePost = "writepost"
    case explore = "explore"
    case myPage = "myPage"
    
    var icon: Image {
        switch self {
        case .home:
            return .init(.Tab.homeUnselected)
        case .community:
            return .init(.Tab.communityUnselected)
        case .writePost:
            return .init(.Tab.add)
        case .explore:
            return .init(.Tab.exploreUnselected)
        case .myPage:
            return .init(.Tab.myPageUnselected)
        }
    }
}

struct MainTabView: View {
    
    @EnvironmentObject private var container: DIContainer
    @State private var selectedTab: TabCase = .home
    
    var body: some View {
        NavigationStack(path: $container.router.destinations) {
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
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .calendar:
                    Text("Calendar")
                }
            }
        }
    }
    
    /// 탭 레이블 (아이콘 + 텍스트)
    @ViewBuilder
    private func tabLabel(_ tab: TabCase) -> some View {
        VStack(spacing: 8) {
            if(tab == .writePost) {
                tab.icon
                    .renderingMode(.original)
            } else {
                tab.icon
                    .renderingMode(.template)
                    .foregroundStyle(selectedTab == tab ? Color.green : Color.gray)
                
                Text(tab.rawValue)
                    .foregroundStyle(selectedTab == tab ? Color.green : Color.gray)
            }
        }
    }
    
    @ViewBuilder
    private func tabView(tab: TabCase) -> some View {
        Group {
            switch tab {
            case .home:
                Button {
                    container.router.push(.calendar)
                } label: {
                    Text("Home")
                }

            case .community:
                Text("community")
            case .writePost:
                Text("writePost")
            case .explore:
                Text("explore")
            case .myPage:
                Text("myPage")
            }
        }
        .environmentObject(container)
    }
}

#Preview {
    MainTabView()
        .environmentObject(DIContainer())
}
