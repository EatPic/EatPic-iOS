//
//  BlockedUsersManager.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/9/25.
//

import Foundation

@Observable
final class BlockedUsersManager {
    static let shared = BlockedUsersManager()
    
    private(set) var blockedUserIds: Set<String> = []
    
    private init() {}
    
    func blockUser(userId: String) {
        blockedUserIds.insert(userId)
        // TODO: 실제 서버에 차단 API 호출
    }
    
    func unblockUser(userId: String) {
        blockedUserIds.remove(userId)
        // TODO: 실제 서버에 차단 해제 API 호출
    }
    
    func isBlocked(userId: String) -> Bool {
        return blockedUserIds.contains(userId)
    }
}
