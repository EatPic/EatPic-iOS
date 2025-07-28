//
//  MapViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/25/25.
//

import SwiftUI
import MapKit

/// MapKitView를 위한 ViewModel입니다.
/// 지도 중심 위치와 마커 정보를 관리합니다.
///
/// - Parameters
///     - markers: 지도에 표시할 마커 배열입니다. 보통은 하나의 식당 좌표를 포함합니다.
@Observable
final class MapViewModel {
    
    var cameraPosition: MapCameraPosition
    var makers: [Marker]
    
    init(makers: [Marker]) {
        self.makers = makers
        if let first = makers.first {
            self.cameraPosition = .region(MKCoordinateRegion(
                center: first.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ))
        } else {
            self.cameraPosition = .automatic
        }
    }
}
