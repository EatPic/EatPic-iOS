//
//  LoginViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/27/25.
//

import Foundation
import Moya

/// 로그인 화면에서 사용되는 ViewModel
/// 추후 소셜 로그인 및 키체인 흐름 관리 구현 예정
@Observable
class LoginViewModel {
    
    // MARK: - Property
    
    /// 로그인 API 프로파이더
    private let emailLoginProvider: MoyaProvider<AuthTargetType>
    private let keychain: UserSessionKeychainService // 추가
    /// 사용자 입력 이메일
    var email: String = ""
    
    /// 사용자 입력 비밀번호
    var password: String = ""

    // MARK: - Init
    
    init(container: DIContainer) {
        self.emailLoginProvider = container.apiProviderStore.auth()
        self.keychain = container.userSessionKeychain // 추가
    }
    
    // MARK: - Func
    
    /// 이메일로 로그인 API 요청 함수
    func emailLogin() async {
        /// APIProviderStore에서 제작된 함수 호출
        do {
            let request = EmailLoginRequest(email: email, password: password)
            let response = try await emailLoginProvider.requestAsync(
                .emailLogin(request: request)
            )
            
            let dto = try JSONDecoder().decode(
                TokenResponse.self,
                from: response.data
            )
            
            // 키체인에 저장할 UserInfo 생성
            var userInfo = UserInfo(
                accessToken: dto.result.accessToken,
                refreshToken: dto.result.refreshToken
                // userId, 닉네임 등 여기에 추가
            )
            
            guard keychain.saveSession(userInfo, for: .userSession) else {
                throw NSError(
                    domain: "eatpic.auth",
                    code: -10,
                    userInfo: [NSLocalizedDescriptionKey: "키체인에 세션 저장 실패"]
                )
            }
            
            print(dto)
            print("keychain load: \(keychain.loadSession(for: .userSession))")
        }
        
        catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
    
    func logout() {
        keychain.deleteSession(for: .userSession) // 키체인에서 세션 삭제
        // 필요시 추가 로직 작성하면 될듯
    }
    
    var fieldsNotEmpty: Bool {
        !email.isEmpty && !password.isEmpty
    }
}

