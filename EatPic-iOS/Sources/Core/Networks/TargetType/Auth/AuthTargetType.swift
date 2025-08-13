//
//  AuthTargetType.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Moya

/// 로그인 등의 인증 요청을 위한 API를 정의하는 TargetType입니다.
enum AuthTargetType {
    case emailLogin(request: EmailLoginRequest)
    case login(email: String, password: String)
    case signup(request: SignupRequest)
}

extension AuthTargetType: APITargetType {
    var path: String {
        switch self {
        case .login:
            return "api/auth/login/social"
        case .signup:
            return "/api/auth/signup"
        case .emailLogin:
            return "/api/auth/login/email"
        }
    }

    var method: Moya.Method {
        switch self {
        case .emailLogin, .login, .signup:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .login(email, password):
            let parameters = ["email": email, "password": password]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .signup(let request):
            return .requestJSONEncodable(request)
        case .emailLogin(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var sampleData: Data {
        return Data("""
                {
                    "user_id": 1,
                    "token": "jwt-token"
                }
                """.utf8)
    }
}

