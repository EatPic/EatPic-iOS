//
//  CLAuthorizationStatus+Extensions.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/15/25.
//

import Foundation
import CoreLocation

extension CLAuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined: return "결정되지 않음"
        case .restricted: return "제한됨"
        case .denied: return "거부됨"
        case .authorizedAlways: return "항상 허용"
        case .authorizedWhenInUse: return "앱 사용 중 허용"
        @unknown default: return "알 수 없음"
        }
    }
}
