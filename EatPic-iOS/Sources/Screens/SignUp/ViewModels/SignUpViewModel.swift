//
//  LoginViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import Foundation

/// 로그인 화면 초기 ViewModel
@Observable
class SignUpViewModel {
    
    // MARK: - Property
    
    /// 사용자 입력 이메일
    var email: String = ""
    
    /// 사용자 입력 비밀번호
    var password: String = ""
    
    /// 사용자 입력 닉네임
    var nickname: String = ""
    
    /// 사용자 입력 아이디
    var id: String = ""
    
    // MARK: - Logic

    var fieldsNotEmpty: Bool {
        !email.isEmpty && !password.isEmpty
    }
}
