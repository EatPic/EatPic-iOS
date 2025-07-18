//
//  NetworkService.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 7/18/25.
//

import Foundation
import Moya

protocol NetworkService {
    var isTokenExpiringSoon: Bool { get }
    
    func createProvider<T: TargetType>(
        for targetType: T.Type,
        additionalPlugins: [PluginType]
    ) -> MoyaProvider<T>
    
    func testProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T>
}

/// 기본값을 제공하는 extension
extension NetworkService {
    func createProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return createProvider(for: targetType, additionalPlugins: [])
    }
}
