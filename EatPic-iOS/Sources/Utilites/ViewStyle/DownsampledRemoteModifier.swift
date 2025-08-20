//
//  DownsampledRemoteModifier.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/20/25.
//

import SwiftUI
import Kingfisher

struct DownsampledRemoteModifier: ViewModifier {
    let url: String
    let contentMode: ImageContentMode
    let targetSize: CGSize?   // 없으면 뷰 실제 크기 측정

    @State private var measured: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geo in
                Color.clear
                    .onAppear { measured = geo.size }
            })
            .overlay(
                KFImage(URL(string: url))
                    .placeholder { Color.gray.opacity(0.12)
                    }
                    .setProcessor(
                        DownsamplingImageProcessor(size: effectivePixelSize())
                    )
                    .cacheOriginalImage()
                    .scaleFactor(UIScreen.main.scale)
                    .loadDiskFileSynchronously()
                    .backgroundDecode()
                    .cancelOnDisappear(true)
                    .resizable()
                    .modifier(Mode(mode: contentMode))
            )
            .clipped()
            .accessibilityHidden(true)
    }

    private func effectivePixelSize() -> CGSize {
        let size = targetSize ?? measured
        let scale = UIScreen.main.scale
        return CGSize(
            width: max(1, size.width * scale),
            height: max(1, size.height * scale)
        )
    }

    private struct Mode: ViewModifier {
        let mode: ImageContentMode
        func body(content: Content) -> some View {
            switch mode {
            case .fit:  content.scaledToFit()
            case .fill: content.scaledToFill()
            @unknown default: content.scaledToFit()
            }
        }
    }
}

enum ImageContentMode {
    case fit
    case fill
}

extension View {
    func downsampledRemoteImage(
        url: String,
        contentMode: ImageContentMode = .fill,
        targetSize: CGSize? = nil) -> some View {
        modifier(
            DownsampledRemoteModifier(
                url: url,
                contentMode: contentMode,
                targetSize: targetSize
            )
        )
    }
}
