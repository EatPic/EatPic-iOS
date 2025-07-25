//
//  StoreLocationView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/25/25.
//

import SwiftUI

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
