//
//  SignUpViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/31/25.
//

import Foundation

/// 로그인 화면 초기 ViewModel
@Observable
class SignUpViewModel {
    
    // MARK: - Property
    
    /// 가입된 사용자 이메일 테스트 용 데이터
    let registeredEmails = ["test@example.com", "abc@gmail.com"]
    
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
    
    // MARK: - Logic

    var fieldsNotEmpty: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - 비밀번호 유효성 검사 Function
    
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
