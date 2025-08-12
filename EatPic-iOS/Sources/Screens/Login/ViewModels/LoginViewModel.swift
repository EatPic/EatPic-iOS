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
    
    /// 로그인 상태
    var isLogin: Bool = false
    var loginError: String?
    
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
            // 상태 코드가 200~299면 → 그대로 Response를 반환, 그렇지 않으면 → MoyaError.statusCode throw
            try response.filterSuccessfulStatusCodes()
            
            let dto = try JSONDecoder().decode(
                TokenResponse.self,
                from: response.data
            )
            
            // 키체인에 저장할 UserInfo 생성
            let userInfo = UserInfo (
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
            print("keychain load: \(String(describing: keychain.loadSession(for: .userSession)))")
            
            loginError = nil
            isLogin = true
        } catch {
            loginError = "이메일과 비밀번호가 일치하지 않습니다."
            isLogin = false
            print("로그인 실패:", error.localizedDescription)
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
