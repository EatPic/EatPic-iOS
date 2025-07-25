//
//  Place.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/25/25.
//

import Foundation
import MapKit

struct Place: Identifiable, Hashable {
    let id = UUID()
    
    /// 'MKMapItem 타입 내부 속정
    /// - .name: 장소이름
    /// - .placemark.coordinate: 위도/경도
    /// - .placemark.title: 주소 전체
    /// - .phoneNumber, .url: 전화번호, 웹사이트 등
    let mapItem: MKMapItem
}
