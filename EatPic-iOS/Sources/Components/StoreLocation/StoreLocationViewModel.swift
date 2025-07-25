//
//  StoreLocationViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/25/25.
//

import Foundation
import CoreLocation

/// 식당 위치 화면 전용 ViewModel입니다.
@Observable
class StoreLocationViewModel {
    
    private let geocoder = CLGeocoder()
    
    let makers: [Marker]
    var address: String = "식당 위치 로딩 중.."
    
    init(makers: [Marker]) {
        self.makers = makers
    }
    
    func reverseGeocode() async {
        guard let latitude = makers.first?.coordinate.latitude,
              let longitude = makers.first?.coordinate.longitude else {
            fatalError("식당의 GPS 좌표가 없어 역지오코딩을 할 수 없습니다.")
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(
                location,
                preferredLocale: Locale(identifier: "ko_KR")
            )
            if let placemark = placemarks.first {
                let address = [
                    placemark.locality,
                    placemark.name
                ].compactMap { $0 }.joined(separator: " ")
                
                self.address = address
            }
        } catch {
            print("역지오코딩 에러: \(error.localizedDescription)")
        }
    }
}
