//
//  UserInfo.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/16/25.
//

import Foundation

/// 사용자 인증 정보를 담는 모델입니다.
/// accessToken과 refreshToken은 JWT 기반 인증에서 사용됩니다.
struct UserInfo: Codable {
    /// 서버에서 발급받은 Access Token입니다.
    var accessToken: String?
    
    /// 서버에서 발급받은 Refresh Token입니다.
    var refreshToken: String?
}
