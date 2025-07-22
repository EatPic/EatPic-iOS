//
//  TokenProvider.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Moya
import Alamofire

/// 액세스 및 리프레시 토큰을 관리하고, 리프레시 요청을 수행하는 책임을 갖는 클래스입니다.
/// 내부적으로 Keychain을 통해 세션 정보를 저장/로드하며,
/// 토큰이 만료될 경우 서버에 리프레시 요청을 보내 새로운 토큰을 갱신합니다.
class TokenProvider: TokenProviding {
    private let userSessionKeychain: UserSessionKeychainService
    private let provider = MoyaProvider<AuthRouter>()
    
    init(userSessionKeychain: UserSessionKeychainService) {
        self.userSessionKeychain = userSessionKeychain
    }
    
    /// 현재 저장된 액세스 토큰입니다.
    /// Keychain에 저장된 세션에서 토큰을 불러오거나 설정합니다.
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
    
    /// 현재 저장된 리프레시 토큰입니다.
    /// Keychain에 저장된 세션에서 토큰을 불러오거나 설정합니다.
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
    
    /// 서버에 리프레시 토큰을 전송하여 새로운 액세스 토큰을 요청합니다.
    /// - Parameter completion: 새 토큰 또는 오류를 반환하는 콜백
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
    
    /// 현재 액세스 토큰의 만료 시점을 판단하여, 지정된 시간 내에 만료 예정인지 여부를 반환합니다.
    /// - Parameter buffer: 현재 시간으로부터의 여유 시간(초) (기본값: 3000초)
    /// - Returns: 만료 임박 여부
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
    
    /// Keychain에서 사용자 세션을 삭제합니다.
    func clearSession() {
        userSessionKeychain.deleteSession(for: .userSession)
        print("Keychain에서 사용자 세션 삭제 완료")
    }
}
