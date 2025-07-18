//
//  APIProviderStore.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 7/19/25.
//

import Foundation
import Moya

final class APIProviderStore {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension APIProviderStore {
    func user() -> MoyaProvider<UserTargetType> {
        return networkService.testProvider(for: UserTargetType.self)
    }
}
