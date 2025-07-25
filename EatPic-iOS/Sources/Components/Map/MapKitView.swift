//
//  MapKitView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/23/25.
//

import SwiftUI
import CoreLocation
import MapKit
import UIKit

/// MapKit을 SwiftUI에서 사용하기 위한 UIViewRepresentable 구현체입니다.
/// 마커와 카메라 포지션을 기반으로 지도를 표시합니다.
struct MapKitView: UIViewRepresentable {
    @Bindable private var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = context.coordinator
        
        // 중심 위치 설정
        if let first = viewModel.makers.first {
            let region = MKCoordinateRegion(
                center: first.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
            mapView.setRegion(region, animated: false)
        }
        
        // 마커 추가
        for marker in viewModel.makers {
            let annotation = MKPointAnnotation()
            annotation.coordinate = marker.coordinate
            annotation.title = marker.title
            mapView.addAnnotation(annotation)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(
            _ mapView: MKMapView,
            viewFor annotation: any MKAnnotation
        ) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "CustomMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(
                    annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            annotationView?.image = UIImage(resource: .Map.marker)
            
            return annotationView
        }
    }
}

#Preview {
    MapKitView(viewModel: .init(makers: [
        .init(coordinate: .init(latitude: 37.587964, longitude: 127.007662), title: "방목")
    ]))
}
