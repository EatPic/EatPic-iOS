//
//  MapViewAdapter.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/25/25.
//

import SwiftUI

/// MapKit 기반의 지도 뷰를 반환하는 어댑터입니다.
final class MapViewAdapter: MapRepresentable {
    func makeMapView(with markers: [Marker]) -> AnyView {
        let viewModel: MapViewModel = .init(makers: markers)
        return AnyView(MapKitView(viewModel: viewModel))
    }
}
