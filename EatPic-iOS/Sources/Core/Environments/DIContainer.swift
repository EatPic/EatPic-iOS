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
        self.networkService = NetworkServiceImpl(
            userSessionKeychain: userSessionKeychain
        )
        self.apiProviderStore = APIProviderStore(networkService: networkService)
        self.mediaPickerService = mediaPickerService
    }
    
    // MARK: - FlowViewModel Factory Property
    
    @MainActor var recordFlowVM: RecordFlowViewModel?
    var signupFlowVM: SignupFlowViewModel?
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
