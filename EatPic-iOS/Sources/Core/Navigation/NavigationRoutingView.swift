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
    case calendar
    case notification
    case emailLoginView
    case signUpEmailView
    case signupPasswordView
    case signupNicknameView
    case signupIdView
    case signupProfileView
    case signupAgreementView
    case agreementMarketingView
    case agreementPrivacyView
    case agreementServiceView
    case signupComplementView
    case home
    case myBadgeStatusAll
    case picCardEdit
    case calenderCard
    case myMemo
    case receiptDetail
    case exploreMain
    case mealTimeSelection(image: [UIImage])
    case hashtagSelection
    case picCardRecord
    case userProfile(user: CommunityUser)
    case followList(selected: FollowListView.FollowSegment)
    case exploreSelected
    case storeLocation(latitude: Double, longitude: Double, title: String)
    case settingPage
    case blockedAccount
    case profileEdit
}

/// 화면 전환을 위한 라우팅 처리 전용 View입니다.
/// `NavigationRoute`를 기반으로 해당 목적지에 해당하는 실제 화면을 렌더링합니다.
/// `NavigationStack`의 `navigationDestination(for:)` 내부에서 사용되며,
/// 라우팅에 따라 적절한 화면을 분기 처리하는 역할을 담당합니다.
struct NavigationRoutingView: View {
    
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var appFlowViewModel: AppFlowViewModel
    @StateObject private var recordViewModel = PicCardRecorViewModel()  // 하나의 뷰모델 생성
        
    private let route: NavigationRoute
    
    init(route: NavigationRoute) {
        self.route = route
    }
    
    var body: some View {
        routingView
            .environmentObject(container)
    }
    
    @ViewBuilder
    private var routingView: some View {
        switch route {
        case .calendar:
            CalendarScrollView(container: container)
        case .notification:
            NotificationView()
        case .emailLoginView:
            EmailLoginView(
                container: container,
                appFlowViewModel: appFlowViewModel
            )
        case .signUpEmailView:
            SignupEmailView(
                viewModel: SignupEmailViewModel(
                    flow: container.getSignupFlowVM()
                )
            )
        case .signupPasswordView:
            SignupPasswordView(
                viewModel: SignupPasswordViewModel(
                    flow: container.getSignupFlowVM()
                ))
        case .signupNicknameView:
            SignupNicknameView(
                viewModel: SignUpNicknameViewModel(
                    flow: container.getSignupFlowVM()
                ))
        case .signupIdView:
            SignupIdView(
                viewModel: SignUpIdViewModel(
                    flow: container.getSignupFlowVM()
                ))
        case .signupProfileView:
            SignupProfileView()
        case .signupAgreementView:
            SignupAgreementView()
        case .agreementMarketingView:
            AgreementMarketingView()
        case .agreementPrivacyView:
            AgreementPrivacyView()
        case .agreementServiceView:
            AgreementServiceView()
        case .signupComplementView:
            SignupComplementView(
                viewModel: container.getSignupFlowVM()
            )
        case .home:
            HomeView()
        case .myBadgeStatusAll:
            MyBadgeStatusAllView()
        case .picCardEdit:
            PicCardEditView()
        case .calenderCard:
            CalenderCardView()
        case .myMemo:
            MyMemoView()
        case .receiptDetail:
            ReceiptDetailView()
        case .exploreMain:
            ExploreMainView()
        case .mealTimeSelection(let images):
            let recordFlowViewModel = container.getRecordFlowVM()
            MealRecordView()
                .task {
                    recordFlowViewModel
                        .bootstrapIfNeeded(createdAt: Date(), images: images)
                }
                .environmentObject(recordFlowViewModel)
        case .hashtagSelection:
            if let recordFlowViewModel = container.recordFlowVM {
                HashtagSelectingView().environmentObject(recordFlowViewModel)
            } else {
                HashtagSelectingView() // fallback: 로그/어설트 추가 필요
            }
            
        case .picCardRecord:
            if let recordFlowViewModel = container.recordFlowVM {
                PicCardRecorView().environmentObject(recordFlowViewModel)
            } else {
                PicCardRecorView()
            }
        case .userProfile(let user):
            OthersProfileView(user: user)
        case .followList(let selected):
            FollowListView(selected: selected)
        case .exploreSelected:
            ExploreSelectedView()
        case .storeLocation(let latitude, let longitude, let title):
            StoreLocationView(
                markers: [.init(
                    coordinate: .init(latitude: latitude, longitude: longitude),
                    title: title
                )]
            )
        case .settingPage:
            SettingPageView()
        case .blockedAccount:
            BlockedAccountView()
        case .profileEdit:
            ProfileEditView()
        }
    }
}
