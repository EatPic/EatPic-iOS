//
//  NavigationRouter.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import Foundation

enum NavigationRoute: Equatable, Hashable {
    case home
    case community
    case writePost
    case explore
    case myPage
}

/// 화면 이동을 제어하기 위한 라우팅 프로토콜
protocol NavigationRoutable: AnyObject {
    /// 현재 네비게이션 스택에 쌓여 있는 목적지들
    var destinations: [NavigationRoute] { get set }

    /// 새로운 화면을 네비게이션 스택에 푸시
    func push(_ destination: NavigationRoute)

    /// 현재 화면을 팝 (뒤로 가기)
    func pop()

    /// 루트 화면까지 모두 팝 (처음 화면으로 이동)
    func popToRoot()
    
    /// 목적지를 포함하고 있는지 여부
    func contains(_ destination: NavigationRoute) -> Bool
}

/// SwiftUI에서 상태를 추적할 수 있도록 Observable로 선언된 라우터 클래스
@Observable
final class NavigationRouter: NavigationRoutable {
    
    /// 현재까지 쌓인 화면 목적지 목록 (화면 전환 상태)
    var destinations: [NavigationRoute] = []
    
    /// 화면을 새로 추가 (푸시)
    func push(_ destination: NavigationRoute) {
        destinations.append(destination)
    }
    
    /// 마지막 화면을 제거 (뒤로 가기)
    func pop() {
        _ = destinations.popLast()
    }
    
    /// 스택을 초기화하여 루트 화면으로 이동
    func popToRoot() {
        destinations.removeAll()
    }
    
    /// 목적지 포함 여부
    func contains(_ destination: NavigationRoute) -> Bool {
        destinations.contains(destination)
    }
}
