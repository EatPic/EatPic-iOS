//
//  SignupPasswordViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/5/25.
//

import Foundation

/// 회원가입 비밀번호 입력창 ViewModel
@Observable
class SignupPasswordViewModel: SignupFlowViewModel {
    
    // MARK: - Property
    
    /// 사용자 입력 비밀번호
    override var password: String {
        get { super.password }
        set { super.password = newValue }
    }
    
    override var confirmPassword: String {
        get { super.confirmPassword}
        set { super.confirmPassword = newValue }
    }
    
    // MARK: - Error Message
    
    /// 비밀번호 검사 에러 메시지
    var passwordErrorMessage: String? {
        if password.isEmpty {
            return nil
        } else if !isPasswordCountValid {
            return "6자리 이상의 비밀번호를 입력해주세요."
        } else {
            return nil
        }
    }
    
    /// 비밀번호 확인 검사 에러 메시지
    var confirmPasswordErrorMessage: String? {
        if confirmPassword.isEmpty {
            return nil
        } else if password != confirmPassword {
            return "비밀번호가 일치하지 않습니다."
        }
        return nil
    }
    
    // MARK: - 비밀번호 유효성 검사 Func
    
    /// 비밀번호 유효성 검사
    var isPasswordValid: Bool {
        isPasswordConfirmed && isPasswordCountValid
    }
    
    /// 비밀번호 6자리 유효성 검사
    var isPasswordCountValid: Bool {
        password.count >= 6
    }
    
    /// 비밀번호 확인 일치 여부 검사
    var isPasswordConfirmed: Bool {
        password == confirmPassword
    }
}
