//
//  SignUpViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/31/25.
//

import Foundation
import Moya

/// 회원가입 플로우 중앙 뷰 모델
@Observable
class SignupFlowViewModel {
    // MARK: - Property
    
    /// 사용자 입력 이메일
    var email: String = ""
    
    /// 사용자 입력 비밀번호
    var password: String = ""
    
    /// 비밀번호 확인
    var confirmPassword: String = ""
    
    /// 사용자 입력 닉네임
    var nickname: String = ""
    
    /// 사용자 입력 아이디
    var id: String = ""

    /// API 연결을 위한 프로바이더
    private var authProvider: MoyaProvider<AuthTargetType>
    
    // MARK: - Init
    init(container: DIContainer) {
        self.authProvider = container.apiProviderStore.auth()
    }
    
    // MARK: - Func (API 호출 및 키체인 저장)
    
    func fetchAuth() async {
        do {
            let request = SignupRequest(
                role: SignupDefaults.role,
                email: email,
                password: password,
                passwordConfirm: confirmPassword,
                nameId: id,
                nickname: nickname,
                termsAgreed: SignupDefaults.termsAgreed,
                privacyPolicyAgreed: SignupDefaults.privacyPolicyAgreed,
                marketingAgreed: SignupDefaults.marketingAgreed,
                notificationAgreed: SignupDefaults.notificationAgreed
            )
            
            let response = try await authProvider.requestAsync(
                .signup(request: request)
            )
        } catch {
            print("회원가입 실패:", error)
        }
    }
}
