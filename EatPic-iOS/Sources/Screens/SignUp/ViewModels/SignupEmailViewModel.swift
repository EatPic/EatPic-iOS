//
//  LoginViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import Foundation

/// 이메일로 회원가입 ViewModel
@Observable
class SignupEmailViewModel {
    
    // MARK: - Property
    
    /// 가입된 사용자 이메일 테스트 용 데이터
    let registeredEmails = ["test@example.com", "abc@gmail.com"]
    
    /// 사용자 입력 이메일
    var email: String = ""
    
    /// 에러 메시지
    var emailErrorMessage: String? {
        if email.isEmpty {
                return nil
            } else if !isValidEmailFormat {
                return "유효한 이메일을 입력해주세요."
            } else if isEmailDuplicate {
                return "이미 가입된 이메일입니다. 로그인해주세요."
            } else {
                return nil
            }
    }
    
    // MARK: - 이메일 유효성 검사 Function
    
    /// 유효성 통과 여부
    var isEmailValid: Bool {
        isValidEmailFormat && !isEmailDuplicate
    }
    
    /// 이메일 형식 유효성 검사 (예: abc @gmail.ac.kr, @naver.com, @hanmail.net)
    var isValidEmailFormat: Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
           return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    /// 이메일 중복 여부 검사 (추후 서버 요청 예정)
    var isEmailDuplicate: Bool {
        registeredEmails.contains(email.lowercased())
    }
}
