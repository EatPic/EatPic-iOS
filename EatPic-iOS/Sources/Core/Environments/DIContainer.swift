//
//  DIContainer.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import Foundation

final class DIContainer: ObservableObject {
    @Published var router: NavigationRouter
    @Published var locationStore: LocationStore
    
    init(
        router: NavigationRouter = .init(),
        locationStore: LocationStore = .init(),
    ) {
        self.router = router
        self.locationStore = locationStore
    }
}
