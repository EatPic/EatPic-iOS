//
//  SignupModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/13/25.
//

import Foundation

/// 회원가입 플로우 데이터 한곳에서 응집
struct SignupModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var nickname: String = ""
    var nameId: String = ""
}
