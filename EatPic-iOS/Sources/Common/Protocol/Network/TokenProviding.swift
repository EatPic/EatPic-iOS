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
}
