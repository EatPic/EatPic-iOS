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
        // 홈 탭 화면: 예시로 버튼 클릭 시 calendar 화면으로 이동
        // 예시이므로 HomeView 완성시 지우고 HomeView 추가하면 됩니다.(주석도 함께 지워주세요!)
        case .home:
            Button {
                container.router.push(.calendar)
            } label: {
                Text("Home")
            }

        // 커뮤니티 탭 화면: 커뮤니티 관련 화면을 연결
        // Home과 마찬가지로 화면이 완성되었다면, 지우고 ComunityView를 연결하면 됩니다.
        case .community:
            CommunityMainView()
            
        // 글쓰기 탭 화면: 글쓰기 관련 화면을 연결
        case .writePost:
            MealTimeSelectView()
            // FIXME: CameraModelView() 이후 앨범 또는 카메라 사진 받은 후 -> HashtagSelectionView로 이동

        // 탐색 탭 화면: 탐색 관련 화면을 연결
        case .explore:
            ExploreMainView()

        // 마이페이지 탭 화면: 마이페이지 관련 화면을 연결
        case .myPage:
            Text("myPage")
        }
    }
}
