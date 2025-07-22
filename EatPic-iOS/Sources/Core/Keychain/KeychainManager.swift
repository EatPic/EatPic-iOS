//
//  KeychainService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/16/25.
//

import Foundation
import Security

/// Security 프레임워크 기반으로 iOS Keychain에 데이터를 저장, 불러오기, 삭제하는 기능을 제공합니다.
/// 이 객체는 상태를 가지지 않으며, 싱글톤으로 사용합니다.
final class KeychainManager: @unchecked Sendable {
    static let shared = KeychainManager()
    
    private init() {}
    
    /// 데이터를 Keychain에 저장합니다. 기존 값이 있다면 먼저 삭제하고 저장합니다.
    ///
    /// - Parameters:
    ///     - data: 저장할 Data 객체
    ///     - key: keychain에 데이터를 저장할 때 사용할 고유 키
    /// - Returns: 저장에 성공하면 true, 실패하면 false를 반환합니다.
    @discardableResult
    func save(_ data: Data, for key: String) -> Bool {
        if load(key: key) != nil {
            _ = delete(key: key)
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            let errMsg = SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString
            print("Keychain Save Failed: \(status) - \(errMsg)")
        }
        return status == errSecSuccess
    }
    
    /// Keychain에서 데이터를 불러옵니다.
    ///
    /// - Parameter key: 불러올 데이터의 키
    /// - Returns: 데이터가 존재하고 불러오기에 성공하면 Data 객체를 반환하고, 그렇지 않으면 nil을 반환합니다.
    func load(key: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status != errSecSuccess {
            let errMsg = SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString
            print("Keychain Load Failed: \(status) -  \(errMsg)")
        }
        
        return item as? Data
    }
    
    /// Keychain에서 데이터를 삭제합니다.
    ///
    /// - Parameter key: 삭제할 데이터의 키
    /// - Returns: 삭제에 성공하면 true, 실패하면 false를 반환합니다.
    @discardableResult
    func delete(key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            let errMsg = SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString
            print("Keychain Delete Failed: \(status) - \(errMsg)")
        }
        
        return status == errSecSuccess
    }
}
