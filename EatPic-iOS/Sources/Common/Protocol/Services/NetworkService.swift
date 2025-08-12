//
//  NetworkService.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 7/18/25.
//

import Foundation
import Moya

/// 네트워크 요청을 관리하는 서비스 프로토콜입니다.
///
/// 이 프로토콜은 MoyaProvider를 생성하여 API 요청을 수행할 수 있도록 합니다.
/// 실제 API 요청용 프로바이더 생성 함수와
/// 테스트를 위한 stub provider 생성 함수를 제공합니다.
/// 또한 토큰 망료 여부를 판단할 수 있는 인터페이스도 포함되어 있습니다.
///
/// 이 프로토콜을 구현함으로써 네트워크 계층의 의존성을 분리하고, 테스트 및 유지보수를 용이하게 만듭니다.
protocol NetworkService {
    /// 현재 저장된 엑세스 토큰이 만료되기 임박했는지를 반환합니다.
    /// 백그라운드 상태나 API 요청 이전에 토큰 만료 여부를 판단하여 선제적으로 토큰 갱신을 할 수 있도록 도와줍니다.
    var isTokenExpiringSoon: Bool { get }
    
    /// 주어진 TargetType에 대해 MoyaProvider를 생성합니다.
    ///
    /// - Parameters:
    ///     - targetType: 사용할 TargetType의 타입입니다.
    ///     - additionalPlugins: 로그, 인증 등 추가적으로 사용할 Moya 플러그인 배열입니다.
    /// - Returns: 설정된 MoyaProvider 인스턴스를 반환합니다.
    func createProvider<T: TargetType>(
        for targetType: T.Type,
        additionalPlugins: [PluginType]
    ) -> MoyaProvider<T>
    
    /// 최초 로그인 및 회원가입 시에 사용합니다.
    ///
    /// - Parameters:
    ///     - targetType: 사용할 TargetType의 타입입니다.
    ///     - additionalPlugins: 로그, 인증 등 추가적으로 사용할 Moya 플러그인 배열입니다.
    /// - Returns: 설정된 MoyaProvider 인스턴스를 반환합니다.
    func createUnauthenticatedProvider<T: TargetType>(
        for targetType: T.Type,
        additionalPlugins: [PluginType]
    ) -> MoyaProvider<T>
    
    /// 테스트용으로 즉시 응답을 반환하는 Stub MoyaProvider를 생성합니다.
    ///
    /// 이 함수는 실제 네트워크 호출 없이, 지정된 TargetType에 대한 테스트를 수행할 때 사용됩니다.
    /// Authorization 헤더나 실제 API 호출이 포함되지 않으며, 테스트 전용입니다.
    ///
    /// - Parameter targetType: 사용할 TargetType의 타입입니다.
    /// - Returns: 즉시 응답을 반환하는 MoyaProvider 인스턴스를 반환합니다.
    func testProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T>
}

/// 플러그인을 따로 지정하지 않고 MoyaProvider를 생성합니다.
///
/// 내부적으로 `additionalPlugins`에 빈 배열을 전달하여 기본 Provider를 생성합니다.
///
/// - Parameter targetType: 사용할 TargetType의 타입입니다.
/// - Returns: 설정된 MoyaProvider 인스턴스를 반환합니다.
extension NetworkService {
    func createProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return createProvider(for: targetType, additionalPlugins: [])
    }
    
    func createUnauthenticatedProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return createUnauthenticatedProvider(for: targetType, additionalPlugins: [])
    }
}
