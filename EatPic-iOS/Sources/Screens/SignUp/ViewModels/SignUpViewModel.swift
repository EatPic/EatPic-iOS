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

    // MARK: - Func
    
    var fieldsNotEmpty: Bool {
        !email.isEmpty && !password.isEmpty
    }
}
