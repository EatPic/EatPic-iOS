//
//  AuthRouter.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/18/25.
//

import Foundation
import Moya

/// 사용자 인증과 관련된 API 요청을 정의하는 라우터입니다.
enum AuthRouter {
    // 리프레쉬 토큰 갱신
    case sendRefreshToken(refreshToken: String)
}

extension AuthRouter: APITargetType {
    var path: String {
        switch self {
        case .sendRefreshToken:
            // TODO: [25.07.17 리버/이재원] - 서버 API 명세서에는 리프레쉬 토큰이 아직 없어서 추후 얘기할 예정
            return "user/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendRefreshToken:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sendRefreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .sendRefreshToken(let refresh):
            var headers = ["Content-Type": "application/json"]
            headers["Refresh-Token"] = "\(refresh)"
            return headers
        }
    }
}
