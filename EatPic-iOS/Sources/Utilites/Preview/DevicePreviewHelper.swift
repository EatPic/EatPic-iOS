//
//  DevicePreviewHelper.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/10/25.
//

import SwiftUI

enum PreviewDeviceType: String, CaseIterable {
    case iPhone15Pro = "iPhone 16 Pro Max"
    case iPhone11 = "iPhone 11"
    
    var previewDevice: PreviewDevice {
        .init(rawValue: self.rawValue)
    }
}

/// 미리보기용 초기화까지 한 줄로 하는 함수
func devicePreviews<Content: View>(
    content: @escaping () -> Content
) -> some View {
    ForEach(PreviewDeviceType.allCases, id: \.self) { device in
        content()
            .previewDevice(device.previewDevice)
            .previewDisplayName(device.rawValue)
    }
}
