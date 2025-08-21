//
//  UserTargetType.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Moya

/// 팔로잉 상태에 따른 enum 케이스
enum FollowStatus: String {
    case following = "FOLLOWING"   // 유저가 팔로잉 하는 목록
    case followed  = "FOLLOWED"    // 유저를 팔로우한 목록
}

enum UserTargetType {
    case getUserInfo
    case getFollowingUserIcon
    case getMyUserIcon
    case getUserFollowList(
        status: FollowStatus,
        userId: Int,
        query: String? = nil,
        limit: Int = 10,    // 기본값 10
        cursor: Int? = nil  // next cursor (optional)
    )
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
        case .getUserFollowList:
            return "/api/search/followList"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo, .getUserFollowList:
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
            
        case let .getUserFollowList(status, userId, query, limit, cursor):
            var params: [String: Any] = [
                "follow status": status.rawValue,
                "userId": userId,
                "limit": max(limit, 1)   // 최소 1 보정
            ]
            if let query, !query.isEmpty { params["query"] = query }
            if let cursor { params["cursor"] = cursor }
            
            // ✅ 디버깅용 로그
            print("👉 FollowList Params:", params)

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.queryString
            )
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
