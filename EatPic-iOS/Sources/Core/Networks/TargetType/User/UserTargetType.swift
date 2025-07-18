//
//  UserTargetType.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Moya

enum UserTargetType {
    case getUserInfo
}

extension UserTargetType: APITargetType {
    var path: String { "/users" }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getUserInfo:
            return Data("""
             {
               "user_name": "itcong",
               "nickname": "잇콩이",
               "image_url": "https://cdn.eatpic.com/image1.jpg",
               "status": "ACTIVE"
             }
            """.utf8)
        }
    }
}
