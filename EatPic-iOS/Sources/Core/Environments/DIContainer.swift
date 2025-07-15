//
//  DIContainer.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import Foundation

final class DIContainer: ObservableObject {
    @Published var router: NavigationRouter
    @Published var locationViewModel: LocationViewModel
    
    init(
        router: NavigationRouter = .init(),
        locationViewModel: LocationViewModel = .init(),
    ) {
        self.router = router
        self.locationViewModel = locationViewModel
    }
}
