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
    
    private let networkService: NetworkService
    
    let userSessionKeychain: UserSessionKeychainService
    let apiProviderStore: APIProviderStore
    
    init(
        router: NavigationRouter = .init(),
        userSessionKeychain: UserSessionKeychainService = UserSessionKeychainServiceImpl()
    ) {
        self.router = router
        self.userSessionKeychain = userSessionKeychain
        self.networkService = NetworkServiceImpl(userSessionKeychain: userSessionKeychain)
        self.apiProviderStore = APIProviderStore(networkService: networkService)
    }
}
