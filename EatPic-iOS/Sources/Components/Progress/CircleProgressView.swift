//
//  CircleProgressView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

/// `CircleProgressView`는 원형 진행률을 시각적으로 표현하는 컴포넌트입니다.
/// 진행률에 따라 회전형 테두리가 채워지며, 중앙에는 아이콘을 표시할 수 있습니다.
/// - Parameters:
///   - progress: 현재 진행률로 0.0부터 1.0 사이의 값을 가집니다.
///   - lineWidth: 원형 테두리의 두께입니다.
///   - gradientColors: 진행률 테두리에 사용할 색상 배열입니다.
///   - size: 전체 컴포넌트의 너비와 높이를 결정하는 크기입니다.
///   - icon: 원 중앙에 표시할 이미지입니다.
///   - iconSize: 아이콘의 크기입니다.
struct CircleProgressView: View {
    let progress: CGFloat           // 진행률 (0.0 ~ 1.0)
    let lineWidth: CGFloat          // 테두리 두께
    let gradientColors: [Color]     // 진행선 색상
    let size: CGFloat               // 전체 크기
    let iconURL: String?        // 내부에 표시할 아이콘 URL
    let iconSize: CGFloat?           // 아이콘 사이즈
    
    init(
        progress: CGFloat,
        lineWidth: CGFloat = 14,
        gradientColors: [Color] = [.pink060],
        size: CGFloat = 128,
        iconURL: String? = nil,
        iconSize: CGFloat? = nil
    ) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.gradientColors = gradientColors
        self.size = size
        self.iconURL = iconURL
        self.iconSize = iconSize
    }

    var body: some View {
            // 링 안쪽 지름 = 전체 - (테두리*2) - 여유
            let innerDiameter = max(0, size - (lineWidth * 2) - 6)
            let iconDiameter = iconSize ?? innerDiameter

            ZStack {
                // 배경 링
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

                // 진행 링
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: gradientColors),
                            center: .center),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .square)
                    )
                    .rotationEffect(.degrees(-90))

                // 중앙 아이콘 (다운샘플링된 서버 이미지)
                if let url = iconURL {
                    Rectangle()
                        .downsampledRemoteImage(               // ✅ 다운샘플링 적용
                            url: url,
                            contentMode: .fit,                 // ✅ 짤림 방지
                            targetSize: CGSize(width: iconDiameter, height: iconDiameter)
                        )
                        .frame(width: iconDiameter, height: iconDiameter)
                        .clipShape(Circle())                   // ✅ 원형 마스킹
                        .clipped()
//                        .allowsHitTesting(false)
                }
            }
            .frame(width: size, height: size)
        }
}
