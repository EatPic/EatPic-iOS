//
//  NavigationRouterTests.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 7/12/25.
//

import Testing
@testable import EatPic_iOS

struct NavigationRouterTests {
    
    let router: NavigationRouter
    
    // 테스트 코드를 함수단위로 실행할때마다 초기화
    init() {
        self.router = NavigationRouter()
    }

    // MARK: - Push Logic

    @Test
    func push_addsDestination() {
        router.push(.calendar)
        router.push(.notification)
        #expect(router.destinations == [.calendar, .notification])
    }

    @Test
    func push_preventsDuplicateDestinationWhenChecked() {
        router.push(.calendar)
        if !router.contains(.calendar) {
            router.push(.notification)
        }
        #expect(router.destinations == [.calendar])
    }

    // MARK: - Pop Logic

    @Test
    func pop_removesLastDestination() {
        router.push(.calendar)
        router.push(.notification)
        router.pop()
        #expect(router.destinations == [.calendar])
    }

    @Test
    func pop_onEmptyStack_doesNothing() {
        router.pop()
        #expect(router.destinations.isEmpty)
    }

    @Test
    func conditionalPop_onlyPopWhenDestinationExists() {
        router.push(.calendar)
        if router.contains(.calendar) {
            router.pop()
        }
        #expect(router.destinations.isEmpty)
    }

    // MARK: - Pop to Root

    @Test
    func popToRoot_clearsAllDestinations() {
        router.push(.calendar)
        router.push(.notification)
        router.popToRoot()
        #expect(router.destinations.isEmpty)
    }

    // MARK: - Contains Logic

    @Test
    func contains_identifiesRouteCorrectly() {
        router.push(.calendar)
        #expect(router.contains(.calendar))
        #expect(!router.contains(.notification))
    }

    @Test
    func contains_usedForUIBranchingSimulation() {
        // 라우팅에 따른 조건 분기 테스트
        router.push(.notification)
        let isNotificationPresented = router.contains(.notification)
        #expect(isNotificationPresented)
    }
    
    @Test
    func contains_backToDestination() {
        router.push(.calendar)
        router.push(.notification)
        
        let destination = NavigationRoute.calendar
        
        if router.contains(destination) {
            while router.destinations.last != destination {
                router.pop()
            }
        }
        #expect(router.destinations == [.calendar])
    }
}
