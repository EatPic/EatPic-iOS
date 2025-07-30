//
//  NavigationRoutingView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/13/25.
//

import SwiftUI

/// 앱 내 화면 전환을 위한 라우팅 목적지를 정의한 열거형입니다.
/// `NavigationStack`의 path 바인딩에 사용되며, 각 화면에 대한 식별자 역할을 합니다.
/// 새로운 화면을 추가할 경우, 여기에 새로운 case를 추가하면 됩니다.
enum NavigationRoute: Equatable, Hashable {
    case emailLoginView
    case signUpEmailView
    case homeView
    case notificationView
    case myBadgeStatusAllView(getBadgeStatus: String)
    case picCardEditView
    case calenderCardView
    case myMemoView
    case receiptDetailView
    case exploreMainView
}

/// 화면 전환을 위한 라우팅 처리 전용 View입니다.
/// `NavigationRoute`를 기반으로 해당 목적지에 해당하는 실제 화면을 렌더링합니다.
/// `NavigationStack`의 `navigationDestination(for:)` 내부에서 사용되며,
/// 라우팅에 따라 적절한 화면을 분기 처리하는 역할을 담당합니다.
struct NavigationRoutingView: View {
    
    @EnvironmentObject private var container: DIContainer
    private let route: NavigationRoute
    
    init(route: NavigationRoute) {
        self.route = route
    }
    
    var body: some View {
        Group {
            switch route {
            case .emailLoginView:
                EmailLoginView()
            case .signUpEmailView:
                SignupEmailView()
            case .homeView:
                HomeView()
            case .notificationView:
                NotificationView()
            case .myBadgeStatusAllView(let getBadgeStatus):
                MyBadgeStatusAllView(getBadgeStatus: getBadgeStatus)
            case .picCardEditView:
                PicCardEditView()
            case .calenderCardView:
                CalenderCardView()
            case .myMemoView:
                MyMemoView()
            case .receiptDetailView:
                ReceiptDetailView()
            case .exploreMainView:
                ExploreMainView()
                
            }
        }
        .environmentObject(container)
    }
}
