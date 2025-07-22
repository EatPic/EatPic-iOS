//
//  DIContainer.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import Foundation

/// 단방향 흐름을 위한 전역 의존성 주입 컨테이너
final class DIContainer: ObservableObject {
    
    @Published var router: NavigationRouter
    @Published var locationStore: LocationStore
    
    private let networkService: NetworkService
    
    let userSessionKeychain: UserSessionKeychainService
    let apiProviderStore: APIProviderStore
    
    init(
        router: NavigationRouter = .init(),
        locationStore: LocationStore = .init(),
        userSessionKeychain: UserSessionKeychainService = UserSessionKeychainServiceImpl()
    ) {
        self.router = router
        self.locationStore = locationStore
        self.userSessionKeychain = userSessionKeychain
        self.networkService = NetworkServiceImpl(userSessionKeychain: userSessionKeychain)
        self.apiProviderStore = APIProviderStore(networkService: networkService)
    }
}
