//
//  KeychainService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/16/25.
//

import Foundation
import Security

final class KeychainManager: @unchecked Sendable {
    static let shared = KeychainManager()
    
    private init() {}
    
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
