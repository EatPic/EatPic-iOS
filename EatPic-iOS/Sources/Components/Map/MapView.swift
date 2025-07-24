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

protocol MapRepresentable {
    func makeMapView(with markers: [Marker]) -> AnyView
}

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
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 현재는 동적 업데이트 없음
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate { }
}

@Observable
class StoreLocationViewModel {
    
    private let geocoder = CLGeocoder()
    
    let makers: [Marker] = [
        .init(coordinate: .init(latitude: 37.587964, longitude: 127.007662), title: "방목")
    ]
    var address: String = "식당 위치 로딩 중.."
    
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

struct StoreLocationView: View {
    
    @EnvironmentObject private var container: DIContainer
    @State private var viewModel: StoreLocationViewModel = .init()
    @State private var toastViewModel: ToastViewModel = .init()
    
    private let mapView: MapRepresentable
    private let toastDuration: TimeInterval = 1.5
    
    init(mapView: MapRepresentable = MapViewAdapter()) {
        self.mapView = mapView
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
    StoreLocationView()
}
