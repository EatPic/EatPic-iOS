//
//  AuthTargetType.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Moya

enum AuthTargetType: APITargetType {
    case login(email: String, password: String)

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
