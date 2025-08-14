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
    
    /// 회원가입 플로우 사용자 입력값 모델
    var model: SignupModel = .init()
    
    /// API 연결을 위한 프로바이더
    private var authProvider: MoyaProvider<AuthTargetType>
    
    // MARK: - Init
    init(container: DIContainer) {
        self.authProvider = container.apiProviderStore.auth()
    }
    
    // MARK: - Func (API 호출 및 키체인 저장)
    
    /// 네트워크 연동 및 모델 매핑
    func fetchAuth() async throws {
        print("📌 Signup model before request:", model) // 요청 전에 상태 확인
        do {
            let request = SignupRequest(
                role: SignupDefaults.role,
                email: model.email,
                password: model.password,
                passwordConfirm: model.confirmPassword,
                nameId: model.nameId,
                nickname: model.nickname,
                termsAgreed: SignupDefaults.termsAgreed,
                privacyPolicyAgreed: SignupDefaults.privacyPolicyAgreed,
                marketingAgreed: SignupDefaults.marketingAgreed,
                notificationAgreed: SignupDefaults.notificationAgreed
            )
            
            let response = try await authProvider.requestAsync(
                .signup(request: request)
            )
            let dto = try JSONDecoder().decode(SignupResponse.self, from: response.data)
            print(dto)
        } catch {
            print("회원가입 실패:", error.localizedDescription)
            throw error
        }
    }
}
