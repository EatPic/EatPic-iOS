//
//  TokenProviding.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/18/25.
//

import Foundation

protocol TokenProviding {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
    func isTokenExpiringSoon(buffer: TimeInterval) -> Bool
}

// 기본값을 제공하는 extension
extension TokenProviding {
    func isTokenExpiringSoon() -> Bool {
        return isTokenExpiringSoon(buffer: 3000)
    }
}
