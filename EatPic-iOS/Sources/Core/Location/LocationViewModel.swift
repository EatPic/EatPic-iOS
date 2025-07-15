//
//  LocationViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/15/25.
//

import Foundation
import CoreLocation

/// 위치 정보를 관리하는 ViewModel입니다.
///
/// `LocationService`를 통해 위치 권한 상태와 현재 위치를 주기적으로 갱신하며,
/// 뷰 계층에서 UI와 바인딩하여 사용할 수 있도록 데이터를 제공합니다.
/// 앱 내 여러 위치 기반 화면에서 공용으로 사용할 수 있습니다.
@Observable
final class LocationViewModel {

    /// 현재 사용자 위치입니다.
    /// timer에 정의된 간격으로 `LocationService`에서 값을 받아와 갱신됩니다.
    var currentLocation: CLLocation?

    /// 위치 권한 상태입니다.
    /// 사용자의 권한 변경에 따라 동적으로 업데이트됩니다.
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// 위치 기능을 제공하는 서비스입니다.
    /// 외부에서 주입받으며, 기본값으로 `LocationServiceImpl`이 사용됩니다.
    private let locationService: LocationService

    /// 위치 갱신을 위한 타이머입니다.
    /// 1초 간격으로 위치 및 권한 상태를 pull 방식으로 가져옵니다.
    private var timer: Timer?
    
    /// ViewModel 초기화 시 위치 서비스 의존성을 주입받습니다.
    init(locationService: LocationService = LocationServiceImpl()) {
        self.locationService = locationService
    }
    
    /// 위치 권한 요청 및 위치 추적을 시작합니다.
    ///
    /// 타이머를 통해 주기적으로 위치 정보와 권한 상태를 업데이트합니다.
    func start() {
        locationService.requestAuthorization()
        locationService.startUpdatingLocation()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            DispatchQueue.main.async {
                self.currentLocation = self.locationService.currentLocation
                self.authorizationStatus = self.locationService.authorizationStatus
            }
        })
    }
    
    /// ViewModel이 메모리에서 해제될 때 호출됩니다.
    ///
    /// 위치 업데이트를 중지하고 타이머를 무효화하여 메모리 누수를 방지합니다.
    deinit {
        locationService.stopUpdatingLocation()
        timer?.invalidate()
    }
}
