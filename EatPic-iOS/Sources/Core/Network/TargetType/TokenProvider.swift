//
//  TokenProvider.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Moya
import Alamofire

enum AuthRouter {
    // 리프레쉬 토큰 갱신
    case sendRefreshToken(refreshToken: String)
}

extension AuthRouter: APITargetType {
    var path: String {
        switch self {
        case .sendRefreshToken:
            // TODO: 서버 API 명세서에는 리프레쉬 토큰이 아직 없어서 추후 얘기할 예정
            return "user/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendRefreshToken:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sendRefreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .sendRefreshToken(let refresh):
            var headers = ["Content-Type": "application/json"]
            headers["Refresh-Token"] = "\(refresh)"
            return headers
        }
    }
}

struct TokenResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserInfo
}

protocol TokenProviding {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}

class TokenProvider: TokenProviding {
    private let userSessionKeychain: UserSessionKeychainService
    private let provider = MoyaProvider<AuthRouter>()
    
    init(userSessionKeychain: UserSessionKeychainService) {
        self.userSessionKeychain = userSessionKeychain
    }
    
    var accessToken: String? {
        get {
            guard let userInfo = userSessionKeychain.loadSession(for: .userSession) else {
                return nil
            }
            return userInfo.accessToken
        }
        set {
            guard var userInfo = userSessionKeychain.loadSession(for: .userSession) else { return }
            userInfo.accessToken = newValue
            if userSessionKeychain.saveSession(userInfo, for: .userSession) {
                print("유저 액세스 토큰 갱신됨: \(String(describing: newValue))")
            }
        }
    }
    
    var refreshToken: String? {
        get {
            guard let userInfo = userSessionKeychain.loadSession(for: .userSession) else {
                return nil
            }
            return userInfo.refreshToken
        }
        
        set {
            guard var userInfo = userSessionKeychain.loadSession(for: .userSession) else { return }
            userInfo.refreshToken = newValue
            if userSessionKeychain.saveSession(userInfo, for: .userSession) {
                print("유저 리프레시 갱신됨")
            }
        }
    }
    
    func refreshToken(completion: @escaping (String?, Error?) -> Void) {
        guard let userInfo = userSessionKeychain.loadSession(for: .userSession),
            let refreshToken = userInfo.refreshToken else {
            let error = NSError(
              domain: "example.com",
              code: -2,
              userInfo: [NSLocalizedDescriptionKey: "UserSession or refreshToken not found"]
            )
            completion(nil, error)
            return
        }
        
        provider.request(.sendRefreshToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                if let jsonString = String(data: response.data, encoding: .utf8) {
                    print("응답 JSON: \(jsonString)")
                } else {
                    print("JSON 데이터를 문자열로 변환할 수 없습니다.")
                }
                
                do {
                    let tokenData = try JSONDecoder().decode(
                        TokenResponse.self, from: response.data)
                    if tokenData.isSuccess {
                        self.accessToken = tokenData.result.accessToken
                        self.refreshToken = tokenData.result.refreshToken
                        completion(self.accessToken, nil)
                    } else {
                        let error = NSError(
                            domain: "example.com",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Token Refresh failed: isSuccess false"
                            ]
                        )
                        completion(nil, error)
                    }
                } catch {
                    print("디코딩 에러: \(error)")
                    completion(nil, error)
                }
                
            case .failure(let error):
                print("네트워크 에러 : \(error)")
                completion(nil, error)
            }
        }
    }
    
    func isTokenExpiringSoon(buffer: TimeInterval = 3000) -> Bool {
        guard let accessToken = self.accessToken,
              let payload = accessToken.split(separator: ".").dropFirst().first,
              let decodedData = Data(base64Encoded: String(payload).padding(
                toLength: ((payload.count+3)/4)*4, withPad: "=", startingAt: 0)),
              let json = try? JSONSerialization.jsonObject(with: decodedData) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            return true
        }
        
        let expiryDate = Date(timeIntervalSince1970: exp)
        let currentDate = Date()
        return expiryDate.timeIntervalSince(currentDate) <= buffer
    }
    
    func clearSession() {
        userSessionKeychain.deleteSession(for: .userSession)
        print("Keychain에서 사용자 세션 삭제 완료")
    }
}

class AccessTokenRefresher: @unchecked Sendable, RequestInterceptor {
    private var tokenProviding: TokenProviding
    private var isRefreshing: Bool = false
    private var requestToRetry: [(RetryResult) -> Void] = []
    
    init(tokenProviding: TokenProviding) {
        self.tokenProviding = tokenProviding
    }
    
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
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard request.retryCount < 1,
              let response = request.task?.response as? HTTPURLResponse,
              [401, 403, 404].contains(response.statusCode) else {
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
