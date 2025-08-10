//
//  APIProviderStore.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 7/19/25.
//

import Foundation
import Moya

/// APIProviderStore는 각 도메인별로 필요한 MoyaProvider를 생성하는 책임을 갖습니다.
/// 네트워크 서비스에 의존하여 필요한 프로바이더를 외부에 제공합니다.
final class APIProviderStore {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension APIProviderStore {
    /// 사용자 API 요청을 위한 MoyaProvider를 반환합니다.
    /// 기본적으로 테스트용 Provider를 반환하도록 구성되어 있습니다.
    /// 추후, 실제 프로바이더로 변경해야 합니다.
    func user() -> MoyaProvider<UserTargetType> {
        return networkService.testProvider(for: UserTargetType.self)
    }
    
    func home() -> MoyaProvider<HomeTargetType> {
        return networkService.testProvider(for: HomeTargetType.self)
    }
}
