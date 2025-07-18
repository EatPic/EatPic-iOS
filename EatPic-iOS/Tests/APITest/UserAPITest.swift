//
//  UserAPITest.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 7/18/25.
//

import SwiftUI
import Testing
import Alamofire
import Moya
@testable import EatPic_iOS

@Suite("UserAPI")
struct UserAPITest {

    @Test("UserTargetType 샘플 데이터 테스트")
    func getUserInfo() async throws {
        // Given
        let provider = MoyaProvider<UserTargetType>(stubClosure: MoyaProvider.immediatelyStub)
        
        // when
        let response = try await provider.requestAsync(.getUserInfo)
        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        
        // then
        #expect(json?["user_name"] as? String == "itcong")
        #expect(json?["nickname"] as? String == "잇콩이")
        #expect(json?["image_url"] as? String == "https://cdn.eatpic.com/image1.jpg")
        #expect(json?["status"] as? String == "ACTIVE")
    }

}
