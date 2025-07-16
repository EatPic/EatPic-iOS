//
//  DIContainer.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import Foundation

final class DIContainer: ObservableObject {
    @Published var router: NavigationRouter
    let userSessionKeychain: UserSessionKeychainService
    
    init(
        router: NavigationRouter = .init(),
        userSessionKeychain: UserSessionKeychainService = UserSessionKeychainServiceImpl()
    ) {
        self.router = router
        self.userSessionKeychain = userSessionKeychain
    }
}
