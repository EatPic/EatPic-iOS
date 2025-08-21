//
//  DIContainer.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import Foundation
import SwiftUI

/// 단방향 흐름을 위한 전역 의존성 주입 컨테이너
final class DIContainer: ObservableObject {
    
    // MAKR: - Router
    @Published var router: NavigationRouter
    
    // MARK: - Store
    @Published var locationStore: LocationStore
    
    // MARK: - Service
    private let networkService: NetworkService
    
    let userSessionKeychain: UserSessionKeychainService
    let apiProviderStore: APIProviderStore
    let mediaPickerService: MediaPickerService
    
    // MARK: - Global UI States
    @Published var activeTab: TabCase = .home
    @Published var foregroundRefreshTick: Int = 0  // 포그라운드 복귀 갱신 신호

    // MARK: - init
    
    init(
        router: NavigationRouter = .init(),
        locationStore: LocationStore = .init(),
        userSessionKeychain: UserSessionKeychainService = UserSessionKeychainServiceImpl(),
        mediaPickerService: MediaPickerService = MediaPickerServiceImpl()
    ) {
        self.router = router
        self.locationStore = locationStore
        self.userSessionKeychain = userSessionKeychain
        self.networkService = NetworkServiceImpl(userSessionKeychain: userSessionKeychain)
        self.apiProviderStore = APIProviderStore(networkService: networkService)
        self.mediaPickerService = mediaPickerService
    }
    
    // MARK: - Global UI State Helpers
    @MainActor
    func setActiveTab(_ tab: TabCase) {
        activeTab = tab
    }
    
    @MainActor
    func bumpForegroundRefresh() {
        foregroundRefreshTick &+= 1
    }
    
    // 필요 시 로그아웃 리셋
    @MainActor
    func resetForLogout() {
        router = .init()
        locationStore = .init()
        activeTab = .home
        foregroundRefreshTick = 0
    }
    
    // MARK: - FlowViewModel Factory Property
    
    @MainActor var recordFlowVM: RecordFlowViewModel?
    @MainActor var communityMainVM: CommunityMainViewModel?
    
    var signupFlowVM: SignupFlowViewModel?
    
    @MainActor
    func getCommunityMainVM() -> CommunityMainViewModel {
        if let viewModel = communityMainVM { return viewModel }
        let viewModel = CommunityMainViewModel(container: self)
        communityMainVM = viewModel
        return viewModel
    }
    
    @MainActor
    func clearCommunityMainVM() {
        communityMainVM = nil
    }
    
}

extension DIContainer {
    @MainActor
    func getRecordFlowVM() -> RecordFlowViewModel {
        if let viewModel = recordFlowVM { return viewModel }
        let viewModel = RecordFlowViewModel()   // 기본값으로 시작
        recordFlowVM = viewModel
        return viewModel
    }
    
    @MainActor
    func clearRecordFlowVM() {
        recordFlowVM = nil
    }
    
    // MARK: - SignupFlow

    func getSignupFlowVM() -> SignupFlowViewModel {
        if let viewModel = signupFlowVM {
            return viewModel
        } else {
            let newViewModel = SignupFlowViewModel(container: self)
            signupFlowVM = newViewModel
            return newViewModel
        }
    }

    func clearSignupFlowVM() {
        signupFlowVM = nil
    }
}
