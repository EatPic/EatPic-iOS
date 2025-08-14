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
    private let container: DIContainer
    
    /// 앱 흐름 상태를 관리하는 AppFlowViewModel
    private var appFlowViewModel: AppFlowViewModel
    
    /// 사용자 입력 이메일
    var email: String = ""
    
    /// 사용자 입력 비밀번호
    var password: String = ""
    
    /// 로그인 에러 메시지 처리
    var loginError: String?
    
    // MARK: - Init
    
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.container = container
        self.emailLoginProvider = container.apiProviderStore.auth()
        self.keychain = container.userSessionKeychain
        self.appFlowViewModel = appFlowViewModel
    }
    
    // MARK: - Func
    
    /// 이메일로 로그인 API 요청 함수
    @MainActor
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
            let userInfo = UserInfo(
                role: dto.result.role,
                userId: dto.result.userId,
                email: dto.result.email,
                accessToken: dto.result.accessToken,
                refreshToken: dto.result.refreshToken
            )
            
            guard keychain.saveSession(userInfo, for: .userSession) else {
                throw NSError(
                    domain: "eatpic.auth",
                    code: -10,
                    userInfo: [NSLocalizedDescriptionKey: "키체인에 세션 저장 실패"]
                )
            }
            
            print(
                "keychain load: \(String(describing: keychain.loadSession(for: .userSession)))"
            )
            
            loginError = nil
            
            // API 호출 완료시 뷰 전환
            await changeView()

            // 2) 다음 틱에서 로그인 스택 정리 (화면엔 안 보임)
            DispatchQueue.main.async {
                self.container.router.popToRoot()
            }
            
            print("로그인 성공")
        } catch {
            loginError = "이메일과 비밀번호가 일치하지 않습니다."
            print("로그인 실패:", error.localizedDescription)
        }
    }
    
    /// 로그인 성공 시 앱의 메인 탭 화면으로 상태 전환
    private func changeView() async {
        await appFlowViewModel.changeAppState(.tab)
    }
    
    func logout() {
        keychain.deleteSession(for: .userSession) // 키체인에서 세션 삭제
        // 필요시 추가 로직 작성하면 될듯
    }
    
    var fieldsNotEmpty: Bool {
        !email.isEmpty && !password.isEmpty
    }
}
