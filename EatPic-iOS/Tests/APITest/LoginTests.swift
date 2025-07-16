//
//  LoginTests.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Testing
import Moya
@testable import EatPic_iOS

@Suite("LoginTests")
struct LoginTests {

    @Test("AuthTargetType 샘플 데이터 테스트")
    func testAuthLogin() async throws {
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

}
