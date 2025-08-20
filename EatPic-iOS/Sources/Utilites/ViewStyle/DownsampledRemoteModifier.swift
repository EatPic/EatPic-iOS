//
//  DownsampledRemoteModifier.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/20/25.
//

import SwiftUI
import Kingfisher

/// 원격 이미지를 다운샘플링하여 메모리 사용을 줄이고
/// 성능 저하 없이 표시할 수 있는 ViewModifier
///
/// - Parameters:
///   - url: 불러올 이미지의 URL
///   - contentMode: 이미지 맞춤 방식 (`.fit` / `.fill`)
///   - targetSize: 다운샘플링할 기준 크기. 값이 없으면 실제 뷰 크기를 사용
struct DownsampledRemoteModifier: ViewModifier {
    /// 로드할 원격 이미지 URL
    let url: String
    
    /// 이미지 크기 맞춤 방식 (`.fit`, `.fill`)
    let contentMode: ImageContentMode
    
    /// 다운샘플링 목표 사이즈 (지정하지 않으면 실제 뷰 크기 사용)
    let targetSize: CGSize?
    
    /// 뷰에서 측정한 크기 (GeometryReader로 갱신됨)
    @State private var measured: CGSize = .zero

    func body(content: Content) -> some View {
        content
            // 뷰 크기를 측정하여 measured에 반영
            .background(GeometryReader { geo in
                Color.clear
                    .onAppear { measured = geo.size }
            })
            // 실제 네트워크 이미지 오버레이
            .overlay(
                KFImage(URL(string: url))
                    // 플레이스홀더: 회색 박스
                    .placeholder { Color.gray.opacity(0.12) }
                    // 다운샘플링 프로세서 적용
                    .setProcessor(
                        DownsamplingImageProcessor(size: effectivePixelSize())
                    )
                    .cacheOriginalImage()   // 원본 캐싱
                    .scaleFactor(UIScreen.main.scale)
                    .loadDiskFileSynchronously()
                    .backgroundDecode()     // 백그라운드 디코딩
                    .cancelOnDisappear(true)
                    .resizable()
                    // contentMode에 따른 모드 적용
                    .modifier(Mode(mode: contentMode))
            )
            .clipped()
            .accessibilityHidden(true)
    }

    /// 다운샘플링에 사용할 실제 픽셀 단위 사이즈 계산
    private func effectivePixelSize() -> CGSize {
        let size = targetSize ?? measured
        let scale = UIScreen.main.scale
        return CGSize(
            width: max(1, size.width * scale),
            height: max(1, size.height * scale)
        )
    }

    /// contentMode에 따라 이미지 스케일 방식 적용
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

/// 이미지 크기 맞춤 방식을 나타내는 열거형
enum ImageContentMode {
    case fit   /// 비율 유지하며 맞춤
    case fill  /// 비율 유지하며 채움
}

/*
 MARK: - 구현 Notes
 
 ✅ 장점
 - 큰 이미지를 Downsampling 후 표시 → 메모리 사용량 급감, 스크롤 끊김 현상 개선
 - Kingfisher의 캐싱을 그대로 활용 가능 (네트워크 요청 최소화)
 
 ⚠️ 단점
 - GeometryReader로 뷰 크기를 측정해야 하므로 뷰 트리가 약간 복잡해질 수 있음
 - 최초 측정 전에는 placeholder가 보일 수 있음 (UX 고려 필요)
 */
