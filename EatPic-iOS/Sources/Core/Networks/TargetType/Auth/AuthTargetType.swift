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
    case login(email: String, password: String)
}

extension AuthTargetType: APITargetType {
    var path: String {
        return "/auth/login/social"
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case let .login(email, password):
            let parameters = ["email": email, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return Data("""
            {
                "user_id": 1,
                "token": "jwt-token"
            }
            """.utf8)
        }
    }
}
