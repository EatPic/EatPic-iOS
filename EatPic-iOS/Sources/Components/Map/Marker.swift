//
//  Marker.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/25/25.
//

import Foundation
import CoreLocation

struct Marker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}
