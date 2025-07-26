//
//  MapRepresentable.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/25/25.
//

import SwiftUI

/// 지도 View를 추상화하기 위한 프로토콜입니다.
/// 다양한 지도 SDK (MapKit, NaverMap, KakaoMap 등)를 대응할 수 있도록 설계되었습니다.
protocol MapRepresentable {
    /// 마커들을 지도에 표시하는 SwiftUI 뷰를 반환합니다.
    /// - Parameter markers: 지도에 표시할 마커 배열
    /// - Returns: SwiftUI View
    func makeMapView(with markers: [Marker]) -> AnyView
}
