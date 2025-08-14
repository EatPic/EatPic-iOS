//
//  TabViewContent.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/13/25.
//

import SwiftUI

/// `MainTabView`에서 각 탭에 해당하는 화면을 렌더링하는 뷰입니다.
/// 전달받은 `TabCase`에 따라 알맞은 화면 컴포넌트를 반환합니다.
struct TabViewContent: View {
    
    @EnvironmentObject private var container: DIContainer
    private var tab: TabCase
    
    init(tab: TabCase) {
        self.tab = tab
    }
    
    var body: some View {
        switch tab {
        case .home:
            HomeView(container: container)

        case .community:
            CommunityMainView(container: container)
            
        case .writePost:
            EmptyView()

        case .explore:
            ExploreMainView()

        case .myPage:
            MyPageMainView()
        }
    }
}
