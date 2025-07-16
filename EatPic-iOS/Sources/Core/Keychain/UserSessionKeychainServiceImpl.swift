//
//  KeychainService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/16/25.
//

import Foundation

final class UserSessionKeychainServiceImpl: UserSessionKeychainService {
    private let manager: KeychainManager
    
    init(manager: KeychainManager = .shared) {
        self.manager = manager
    }
    
    func saveSession(_ session: UserInfo, for key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(session) else { return false }
        return manager.save(data, for: key)
    }
    
    func loadSession(for key: String) -> UserInfo? {
        guard let data = manager.load(key: key),
              let session = try? JSONDecoder().decode(UserInfo.self, from: data) else { return nil }
        return session
    }
    
    func deleteSession(for key: String) {
        _ = manager.delete(key: key)
    }
}
