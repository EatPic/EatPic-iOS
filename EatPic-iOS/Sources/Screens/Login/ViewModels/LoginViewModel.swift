//
//  LoginViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/27/25.
//

import Foundation

/// 로그인 화면에서 사용되는 ViewModel
/// 추후 소셜 로그인 및 키체인 흐름 관리 구현 예정
@Observable
class LoginViewModel {
    
    // MARK: - Property
    
    /// 사용자 입력 이메일
    var email: String = ""
    
    /// 사용자 입력 비밀번호
    var password: String = ""

    // MARK: - Func
    
    var fieldsNotEmpty: Bool {
        !email.isEmpty && !password.isEmpty
    }
}
