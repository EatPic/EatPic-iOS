//
//  TokenProvider.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Moya
import Alamofire

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
