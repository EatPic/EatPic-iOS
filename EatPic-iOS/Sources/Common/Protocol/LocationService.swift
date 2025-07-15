//
//  LocationService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/15/25.
//

import Foundation
import CoreLocation
import SwiftUI

/// 위치 정보를 외부에 제공하는 추상화된 인터페이스입니다.
///
/// `CLLocationManager`와 같은 시스템 프레임워크에 직접 접근하지 않고,
/// 필요한 위치 정보 기능만 간결하게 사용할 수 있도록 추상화한 프로토콜입니다.
/// 이 인터페이스는 주로 ViewModel 또는 UseCase 계층에서 주입받아 사용되며,
/// 테스트 시에는 `MockLocationService` 등을 통해 대체할 수 있습니다.
protocol LocationService {
    
    /// 현재 사용자 위치입니다.
    ///
    /// `startUpdatingLocation()`을 호출한 후에 최신 위치가 이 프로퍼티에 갱신됩니다.
    /// 위치 정보는 옵셔널이며, 권한이 없거나 초기 상태일 경우 `nil`입니다.
    var currentLocation: CLLocation? { get }

    /// 현재 위치 권한 상태입니다.
    ///
    /// 사용자가 앱에 부여한 위치 권한 상태를 나타내며,
    /// `requestAuthorization()` 호출 이후 변경될 수 있습니다.
    var authorizationStatus: CLAuthorizationStatus { get }

    /// 위치 권한을 요청합니다.
    ///
    /// 사용자에게 위치 권한을 요청하는 시스템 팝업을 트리거하며,
    /// 일반적으로 앱 최초 실행 시 또는 위치 기능이 필요한 시점에 호출합니다.
    func requestAuthorization()

    /// 위치 추적을 시작합니다.
    ///
    /// `currentLocation`이 실시간으로 갱신되기 시작합니다.
    /// ViewModel 또는 View에서 위치 정보가 필요할 때 호출합니다.
    func startUpdatingLocation()

    /// 위치 추적을 중지합니다.
    ///
    /// 리소스 소비를 줄이기 위해, 위치 정보가 더 이상 필요하지 않을 경우 호출합니다.
    func stopUpdatingLocation()
}
