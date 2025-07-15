//
//  LocationService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/15/25.
//

import Foundation
import CoreLocation
import SwiftUI

/// 위치 정보를 외부에 제공하는 추상화 인터페이스
protocol LocationService {
    var currentLocation: CLLocation? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

final class LocationServiceImpl: NSObject, LocationService {
    private let manager = CLLocationManager()
    
    private(set) var currentLocation: CLLocation?
    private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    // 권한 변경 감지
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    // 위치 업데이트 감지
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.last {
            DispatchQueue.main.async {
                self.currentLocation = latest
            }
        }
    }
    
    // 오류 처리
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 오류: \(error.localizedDescription)")
    }
}
