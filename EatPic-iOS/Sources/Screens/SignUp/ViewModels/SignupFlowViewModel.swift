//
//  SignUpViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/31/25.
//

import Foundation

/// 회원가입 플로우 중앙 뷰 모델

@Observable
class SignupFlowViewModel {
    // MARK: - Property (상태만 저장)
    
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

    // MARK: - Func (API 호출 및 키체인 저장)
    
}
