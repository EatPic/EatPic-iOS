//
//  AccessTokenRefresher.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/18/25.
//

import Foundation
import Alamofire

/// 엑세스 토큰을 자동으로 갱신하고, 실패한 요청을 재시도하는 역할을 담당하는 클래스입니다.
/// Alamofire의 `RequestInterceptor`를 채택하여 네트워크 요청을 가로채고,
/// 인증이 필요한 경우 토큰을 추가하거나, 만료 시 자동으로 토큰을 갱신한 뒤 재요청합니다.
class AccessTokenRefresher: @unchecked Sendable, RequestInterceptor {
    private var tokenProviding: TokenProviding
    private var isRefreshing: Bool = false
    private var requestToRetry: [(RetryResult) -> Void] = []
    
    init(tokenProviding: TokenProviding) {
        self.tokenProviding = tokenProviding
    }
    
    /// 네트워크 요청 전에 Authorization 헤더에 액세스 토큰을 설정합니다.
    /// - Parameters:
    ///   - urlRequest: 원본 URLRequest 객체
    ///   - session: 현재 Alamofire 세션
    ///   - completion: 변경된 요청을 반환하는 완료 핸들러
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var urlRequest = urlRequest
        if let accessToken = tokenProviding.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    /// 인증 실패(401, 403) 시 리프레시 토큰을 사용하여 토큰을 갱신하고 요청을 재시도합니다.
    /// - Parameters:
    ///   - request: 실패한 요청
    ///   - session: 현재 Alamofire 세션
    ///   - error: 발생한 오류
    ///   - completion: 재시도 여부를 반환하는 완료 핸들러
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard request.retryCount < 1,
              let response = request.task?.response as? HTTPURLResponse,
              [401, 403].contains(response.statusCode) else {
            return completion(.doNotRetry)
        }
        
        requestToRetry.append(completion)
        if !isRefreshing {
            isRefreshing = true
            tokenProviding.refreshToken { [weak self] _, error in
                guard let self = self else { return }
                self.isRefreshing = false
                
                let result: RetryResult
                if let error = error {
                    result = .doNotRetryWithError(error)
                } else {
                    result = .retry
                }
                
                self.requestToRetry.forEach { $0(result) }
                self.requestToRetry.removeAll()
            }
        }
    }
}
