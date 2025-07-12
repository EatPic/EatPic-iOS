//
//  CircleProgressView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

struct CircleProgressView: View {
    let progress: CGFloat // 0.0 ~ 1.0

    var body: some View {
        ZStack {
            // 배경 원
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 16)

            // 진행 프로그레스
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [.green]), center: .center),
                    style: StrokeStyle(lineWidth: 14, lineCap: .square)
                )
                .rotationEffect(.degrees(-90))

            // 원형 내 이미지 혹은 텍스트
            ZStack {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .frame(width: 48, height: 48)
            }
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    CircleProgressView(progress: 0.2)
}
