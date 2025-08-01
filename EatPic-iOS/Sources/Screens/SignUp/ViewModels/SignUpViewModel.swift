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
    
    /// 가입된 사용자 이메일 테스트용 데이터
    let registeredEmails = ["test@example.com", "abc@gmail.com"]
    
    /// 이미 등록된 닉네임 테스트용 데이터
    let registeredNicknames = ["홍길동", "김철수"]
    
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
    
    var fieldsNotEmpty: Bool {
        !email.isEmpty && !password.isEmpty
    }
}
