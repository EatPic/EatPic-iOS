//
//  ProfileImageView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/16/25.
//

import SwiftUI

/// `ProfileCircleImage`는 원형 프로필 이미지를 나타내는 공용 컴포넌트입니다.
/// - Parameters:
///   - image: 표시할 이미지 (nil일 경우 기본 placeholder 사용)
///   - size: 원형 이미지의 지름 (너비와 높이 동일)
///   - borderColor: 테두리 색상 (기본값 없음)
///   - borderWidth: 테두리 두께 (기본값 0)
struct ProfileImageView: View {
    
    let image: Image?
    let size: CGFloat
    let borderColor: Color
    let borderWidth: CGFloat

    init(
        image: Image? = nil,
        size: CGFloat,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0
    ) {
        self.image = image
        self.size = size
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }

    var body: some View {
        (image ?? Image(systemName: "person.fill")) // 이미지 없으면 기본값 사용
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle()) // 원형으로 자르기
            .overlay(alignment: .center) {
                Circle() // 뷰 위에 테두리 겹쳐 원형 테두리 생성
                    .stroke(borderColor, lineWidth: borderWidth)
            }
            .contentShape(Circle()) // 원형 클릭시만 반응 (사각형 Shape영역 터치시 무반응)
    }
}

#Preview("iPhone 16 Pro Max - Light") {
    ProfileImageView(size: 60, borderColor: .green060,
                     borderWidth: 5)
}
#Preview("iPhone SE (3rd gen) - Light") {
    ProfileImageView(size: 60, borderColor: .gray060,
                     borderWidth: 5)
}
