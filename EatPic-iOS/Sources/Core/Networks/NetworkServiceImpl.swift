//
//  NetworkServiceImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/16/25.
//

import Foundation
import Moya
import Alamofire

/// 네트워크 서비스의 실제 구현체입니다.
///
/// - `TokenProviding`을 통해 액세스 토큰을 주입받고, `AccessTokenRefresher`를 이용해 자동 갱신 처리 로직을 포함합니다.
/// - `Session`과 `MoyaProvider`를 설정하여 API 요청 시 필요한 인증, 로깅, 인터셉터를 적용합니다.
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
    
    func createProvider<T: TargetType>(
        for targetType: T.Type,
        additionalPlugins: [PluginType] = []
    ) -> MoyaProvider<T> {
        return MoyaProvider<T>(
//            session: session,
            plugins: [loggerPlugin] + additionalPlugins
        )
    }
    
    public func testProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return MoyaProvider<T>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [loggerPlugin]
        )
    }
}
