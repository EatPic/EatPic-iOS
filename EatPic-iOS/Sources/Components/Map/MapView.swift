//
//  MapView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/23/25.
//

import SwiftUI
import CoreLocation
import MapKit

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
    
    var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var makers: [Marker] = [
        .init(coordinate: .init(
            latitude: 37.587964, longitude: 127.007662), title: "방목")
    ]
    
    init(locationStore: LocationStore) {
        locationStore.start()
    }
}

struct MapView: View {
    @State private var viewModel: MapViewModel
    @EnvironmentObject private var container: DIContainer
    
    init(container: DIContainer) {
        self.viewModel = .init(locationStore: container.locationStore)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("식당이름")
                .font(.dsTitle3)
                .foregroundStyle(.black)
            
            Spacer().frame(height: 18)
            
            HStack {
                Text("자세한 식당 위치")
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
                        print("복사")
                    }
                )

            }
            
            Spacer().frame(height: 34)
            
            Map(
                position: $viewModel.cameraPosition,
                bounds: .none,
                interactionModes: .all,
            ) {
                ForEach(viewModel.makers, id: \.id, content: { marker in
                    Annotation(marker.title, coordinate: marker.coordinate, content: {
                        Image(systemName: "mappin.circle.fill")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.red)
                    })
                })
            }
            .frame(height: 544)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    MapView(container: .init())
}
