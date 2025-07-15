//
//  LocationViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/15/25.
//

import Foundation
import CoreLocation

@Observable
final class LocationViewModel {
    var currentLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationService: LocationService
    private var timer: Timer?
    
    init(locationService: LocationService = LocationServiceImpl()) {
        self.locationService = locationService
    }
    
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
    
    deinit {
        locationService.stopUpdatingLocation()
        timer?.invalidate()
    }
}
