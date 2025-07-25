//
//  MapView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/23/25.
//

import SwiftUI
import CoreLocation
import MapKit
import UIKit

/// 지도 View를 추상화하기 위한 프로토콜입니다.
/// 다양한 지도 SDK (MapKit, NaverMap, KakaoMap 등)를 대응할 수 있도록 설계되었습니다.
protocol MapRepresentable {
    /// 마커들을 지도에 표시하는 SwiftUI 뷰를 반환합니다.
    /// - Parameter markers: 지도에 표시할 마커 배열
    /// - Returns: SwiftUI View
    func makeMapView(with markers: [Marker]) -> AnyView
}

/// MapKit 기반의 지도 뷰를 반환하는 어댑터입니다.
final class MapViewAdapter: MapRepresentable {
    func makeMapView(with markers: [Marker]) -> AnyView {
        let viewModel: MapViewModel = .init(makers: markers)
        return AnyView(MapKitView(viewModel: viewModel))
    }
}

struct Marker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}

struct Place: Identifiable, Hashable {
    let id = UUID()
    
    /// 'MKMapItem 타입 내부 속정
    /// - .name: 장소이름
    /// - .placemark.coordinate: 위도/경도
    /// - .placemark.title: 주소 전체
    /// - .phoneNumber, .url: 전화번호, 웹사이트 등
    let mapItem: MKMapItem
}

/// MapKitView를 위한 ViewModel입니다.
/// 지도 중심 위치와 마커 정보를 관리합니다.
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

/// 식당의 위치 정보를 지도와 함께 표시하는 View입니다.
///
/// 이 뷰는 식당의 좌표 정보를 기반으로 지도에 마커를 표시하고, 도로명 주소를 표시합니다.
/// 지도 SDK는 `MapKit`을 사용하며, 기본 구현체는 MapViewAdpater 입니다.
///
/// - Parameters
///     - markers: 지도에 표시할 마커 배열입니다. 보통은 하나의 식당 좌표를 포함합니다.
///     - mapView: 지도 구현체. 주입하지 않으면 MapViewAdapter가 기본으로 주입됩니다.
struct StoreLocationView: View {
    
    @EnvironmentObject private var container: DIContainer
    @State private var viewModel: StoreLocationViewModel
    @State private var toastViewModel: ToastViewModel = .init()
    
    private let mapView: MapRepresentable
    private let toastDuration: TimeInterval = 1.5
    
    init(
        markers: [Marker],
        mapView: MapRepresentable = MapViewAdapter()
    ) {
        self.mapView = mapView
        self.viewModel = .init(makers: markers)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("식당이름")
                .font(.dsTitle3)
                .foregroundStyle(.black)
            
            Spacer().frame(height: 18)
            
            HStack {
                Text("\(viewModel.address)")
                    .font(.dsBody)
                    .foregroundStyle(Color.gray060)
                
                Spacer()
                
                PrimaryButton(
                    color: .green060,
                    text: "복사",
                    font: .dsSubhead,
                    textColor: .white,
                    width: 50,
                    height: 23,
                    cornerRadius: 5,
                    action: {
                        UIPasteboard.general.string = viewModel.address
                        
                        toastViewModel.showToast(
                            title: "주소가 복사되었습니다.",
                            duration: toastDuration
                        )
                    }
                )
                
            }
            
            Spacer().frame(height: 34)
            
            mapView.makeMapView(with: viewModel.makers)
                .frame(height: 544)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .toastView(viewModel: toastViewModel)
        .padding(.horizontal, 16)
        .task {
            await viewModel.reverseGeocode()
        }
        .customNavigationBar {
            Text("식당 위치")
        } right: {
            EmptyView()
        }

    }
}

#Preview {
    StoreLocationView(markers: [
        .init(coordinate: .init(latitude: 37.587964, longitude: 127.007662), title: "방목")
    ])
}
