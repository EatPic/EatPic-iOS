//
//  LocationServiceImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/15/25.
//

import Foundation
import CoreLocation

/// 위치 정보를 제공하는 서비스 구현체입니다.
///
/// `CLLocationManager`를 사용하여 현재 위치 및 권한 상태를 추적하며,
/// `LocationService` 프로토콜을 채택하여 ViewModel 등에서 추상화된 형태로 사용될 수 있습니다.
final class LocationServiceImpl: NSObject, LocationService {

    /// 시스템 위치 관리자 인스턴스입니다.
    /// 내부적으로 위치 권한 요청 및 위치 추적 기능을 수행합니다.
    private let manager = CLLocationManager()
    
    /// 현재 사용자 위치입니다.
    /// `startUpdatingLocation()` 이후 delegate를 통해 갱신됩니다.
    private(set) var currentLocation: CLLocation?
    
    /// 현재 위치 권한 상태입니다.
    /// 앱 실행 중 권한이 변경될 경우 delegate를 통해 자동 갱신됩니다.
    private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// 초기화 시 CLLocationManager의 delegate를 self로 설정합니다.
    override init() {
        super.init()
        manager.delegate = self
    }
    
    /// 위치 권한을 요청합니다.
    /// 일반적으로 앱 실행 시 또는 위치 기능 사용 직전에 호출됩니다.
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    /// 위치 추적을 시작합니다.
    /// 이후 `currentLocation`이 주기적으로 갱신됩니다.
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    /// 위치 추적을 중지합니다.
    /// 불필요한 위치 업데이트를 방지하기 위해 필요 시 호출합니다.
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    
    /// 위치 권한 상태가 변경되었을 때 호출됩니다.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    /// 위치가 업데이트될 때 호출됩니다.
    /// 가장 최근 위치를 `currentLocation`에 저장합니다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.last {
            DispatchQueue.main.async {
                self.currentLocation = latest
            }
        }
    }
    
    /// 위치 관련 오류가 발생했을 때 호출됩니다.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 오류: \(error.localizedDescription)")
    }
}
