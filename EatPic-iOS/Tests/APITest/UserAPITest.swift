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

struct UserInfoResponse: Codable {
    let userName: String
    let nickName: String
    let imageUrl: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case nickName = "nickname"
        case imageUrl = "image_url"
        case status = "status"
    }
}

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
    
    @Test("NetworkService를 이용한 UserTargetType 샘플 데이터 테스트")
    func getUserInfoWithNetworkService() async throws {
        // Given
        let mockKeychain = MockUserSessionKeychainService()
        let networkService: NetworkService = NetworkServiceImpl(userSessionKeychain: mockKeychain)
        let userProvider = networkService.testProvider(for: UserTargetType.self)
        
        // when
        let response = try await userProvider.requestAsync(.getUserInfo)
        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        
        // then
        #expect(json?["user_name"] as? String == "itcong")
        #expect(json?["nickname"] as? String == "잇콩이")
        #expect(json?["image_url"] as? String == "https://cdn.eatpic.com/image1.jpg")
        #expect(json?["status"] as? String == "ACTIVE")
    }

}
