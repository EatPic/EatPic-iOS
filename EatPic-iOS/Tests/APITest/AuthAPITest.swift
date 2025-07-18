//
//  AuthAPITest.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 7/17/25.
//

import SwiftUI
import Testing
import Alamofire
import Moya
@testable import EatPic_iOS

/// 실제 키체인 값에 영향을 주지 않기 위해 메모리에서 돌아도록 키체인 서비스 제작
final class MockUserSessionKeychainService: UserSessionKeychainService {
    var session: UserInfo?

    func saveSession(_ session: UserInfo, for type: KeychainKey) -> Bool {
        self.session = session
        return true
    }

    func loadSession(for type: KeychainKey) -> UserInfo? {
        return session
    }

    func deleteSession(for type: KeychainKey) {
        session = nil
    }
}

@Suite("인증 관련 테스트")
struct AuthAPITest {

    @Test("AuthTargetType 샘플 데이터 테스트")
    func authLogin() async throws {
        // Given
        let provider = MoyaProvider<AuthTargetType>(stubClosure: MoyaProvider.immediatelyStub)
        
        // when
        let response = try await provider.requestAsync(
            .login(email: "user@example.com", password: "userpassword"))
        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        
        // then
        #expect(json?["user_id"] as? Int == 1)
        #expect(json?["token"] as? String == "jwt-token")
    }
    
    @Test("adapt 함수를 통해 accessToken이 Authorization 헤더에 포함되어야 한다")
    func addAuthorizationHeader() async throws {
        // Given
        let mockKeychain = MockUserSessionKeychainService()
        mockKeychain.session = UserInfo(
            accessToken: "access-token-123",
            refreshToken: "refresh-token-xyz"
        )
        let tokenProvider = TokenProvider(userSessionKeychain: mockKeychain)
        let refresher = AccessTokenRefresher(tokenProviding: tokenProvider)
        
        var adaptedRequest: URLRequest?
        guard let url = URL(string: "https://example.com") else { return }
        let request = URLRequest(url: url)
        
        // When
        adaptedRequest = try await withCheckedThrowingContinuation { continuation in
            refresher.adapt(request, for: .default) { result in
                switch result {
                case .success(let request):
                    continuation.resume(returning: request)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        // Then
        let header = adaptedRequest?.value(forHTTPHeaderField: "Authorization")
        #expect(header == "Bearer access-token-123")
    }
}
