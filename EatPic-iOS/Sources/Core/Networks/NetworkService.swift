//
//  NetworkService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/16/25.
//

import Foundation
import Moya
import Alamofire

class NetworkServiceImpl: @unchecked Sendable, NetworkService {
    private let tokenProvider: TokenProviding
    private let accessTokenRefresher: AccessTokenRefresher
    private let session: Session
    private let loggerPlugin: PluginType
    
    init(userSessionKeychain: UserSessionKeychainService) {
        tokenProvider = TokenProvider(userSessionKeychain: userSessionKeychain)
        accessTokenRefresher = AccessTokenRefresher(tokenProviding: tokenProvider)
        session = Session(interceptor: accessTokenRefresher)
        
        loggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    }
    
    var isTokenExpiringSoon: Bool {
        tokenProvider.isTokenExpiringSoon()
    }
    
    /// 실제 API 요청용 MoyaProvider
    func createProvider<T: TargetType>(
        for targetType: T.Type,
        additionalPlugins: [PluginType] = []
    ) -> MoyaProvider<T> {
        return MoyaProvider<T>(
            session: session,
            plugins: [loggerPlugin] + additionalPlugins
        )
    }
    
    /// 테스트용 MoyaProvider (stub 응답 사용, Authorization 헤더 없음)
    public func testProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return MoyaProvider<T>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [loggerPlugin]
        )
    }
}
