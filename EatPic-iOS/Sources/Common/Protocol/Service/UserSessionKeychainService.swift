//
//  UserSessionKeychainService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/16/25.
//

import Foundation

/// iOS Keychain에 사용자 세션 정보(JWT 등)을 안전하게 저장하고 불러오는 기능을 제공하는 서비스입니다.
protocol UserSessionKeychainService {
    /// 주어진 키에 해당하는 사용자 세션 정보를 Keychain에 저장합니다.
    ///
    /// - Parameters:
    ///     - session: JWT 토큰 등의 정보를 담고 있는 `UserInfo` 객체입니다.
    ///     - key: 세션 정보를 저장할 때 사용할 고유 키입니다.
    /// - Returns: 저장에 성공하면 `ture`, 실패하면 `false`를 반환합니다.
    func saveSession(_ session: UserInfo, for key: String) -> Bool
    
    /// 주어진 키에 해당하는 사용자 세션 정보를 keychain에서 불러옵니다.
    ///
    /// - Parameters key: 세션 정보가 저장되어 있는 고유 키입니다.
    /// - Returns: 세션 정보를 성공적으로 불러와 디코딩한 경우 `UserInfo` 객체를 반환하고, 실패한 경우 `nil`을 반환합니다.
    func loadSession(for key: String) -> UserInfo?
    
    /// 주어진 키에 해당하는 사용자 세션 정보를 Keychain에서 삭제합니다.
    ///
    /// - Parameter key: 삭제할 세션 정보가 저장되어 있는 고유 키입니다.
    func deleteSession(for key: String)
}
