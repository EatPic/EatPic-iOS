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
    
    // MARK: - Property
    let image: String?
    let size: CGFloat
    let borderColor: Color
    let borderWidth: CGFloat
    
    // MARK: - Init
    init(
        image: String? = nil,
        size: CGFloat,
        borderColor: Color = ProfileImageConstants.defaultBorderColor,
        borderWidth: CGFloat = ProfileImageConstants.defaultBorderWidth
    ) {
        self.image = image
        self.size = size
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    var body: some View {
        Group {
            if let imageName = image {
                // 이미지 이름이 있는 경우
                if isLocalImage(imageName) {
                    // 로컬 이미지인 경우
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    // 원격 이미지인 경우
                    Rectangle()
                        .remoteImage(url: imageName)
                        .scaledToFill()
                }
            } else {
                // 이미지가 없는 경우 기본 placeholder
                ProfileImageConstants.defaultPlaceholderImage
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.gray)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle()) // 원형으로 자르기
        .overlay(alignment: .center) {
            Circle() // 뷰 위에 테두리 겹쳐 원형 테두리 생성
                .stroke(borderColor, lineWidth: borderWidth)
        }
        .contentShape(Circle()) // 원형 클릭시만 반응 (사각형 Shape영역 터치시 무반응)
    }
    
    /// 로컬 이미지인지 판단하는 헬퍼 메서드
    private func isLocalImage(_ imageName: String) -> Bool {
        // URL 형태가 아니면 로컬 이미지로 간주
        return !imageName.hasPrefix("http://") &&
        !imageName.hasPrefix("https://") &&
        !imageName.contains("://")
    }
}

/// ProfileImageView에서 사용되는 텍스트 및 레이아웃 상수를 정의한 내부 열거형
private enum ProfileImageConstants {
    static let defaultBorderColor: Color = .clear
    static let defaultBorderWidth: CGFloat = 0
    static let defaultPlaceholderImage = Image(systemName: "person.fill")
}

#Preview("iPhone 16 Pro Max - Light") {
    ProfileImageView(size: 60, borderColor: .green060,
                     borderWidth: 5)
}

#Preview("iPhone 16 Pro Max - Light") {
    ProfileImageView(size: 60)
}

#Preview("iPhone SE (3rd gen) - Light") {
    ProfileImageView(size: 60, borderColor: .gray060,
                     borderWidth: 5)
}
