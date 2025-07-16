//
//  UserSessionKeychainService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/16/25.
//

import Foundation

protocol UserSessionKeychainService {
    func saveSession(_ session: UserInfo, for key: String) -> Bool
    func loadSession(for key: String) -> UserInfo?
    func deleteSession(for key: String)
}
