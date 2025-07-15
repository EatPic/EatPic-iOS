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
