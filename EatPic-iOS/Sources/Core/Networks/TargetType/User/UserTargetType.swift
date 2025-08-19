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
    case getFollowingUserIcon
    case getMyUserIcon
}

extension UserTargetType: APITargetType {
    var path: String {
        switch self {
        case .getUserInfo:
            return "/users"
        case .getFollowingUserIcon:
            return "/api/users/icons/following"
        case .getMyUserIcon:
            return "/api/users/icons/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .getFollowingUserIcon, .getMyUserIcon:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        case .getFollowingUserIcon, .getMyUserIcon:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
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
