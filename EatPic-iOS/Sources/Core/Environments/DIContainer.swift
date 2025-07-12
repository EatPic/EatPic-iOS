//
//  DIContainer.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import Foundation

final class DIContainer: ObservableObject {
    @Published var router: NavigationRouter
    
    init(router: NavigationRouter = .init()) {
        self.router = router
    }
}
