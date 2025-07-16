//
//  LockBadgeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/16/25.
//
import SwiftUI

/// 뱃지를 아직 획득하지 못했을 때 뜨는 뱃지 뷰
/// - Parameters:
///   - iconImage: 중앙에 표시할 자물쇠 이미지입니다
///   - size: 원형 뱃지 배경의 사이즈
///   - backgroundColor: 원형 뱃지 배경의 색상입니다
struct LockBadgeView: View {
    
    // MARK: - Property
    
    /// 자물쇠 아이콘 이미지
    let iconImage: Image
    
    /// 원형 배경의 사이즈
    let size: CGFloat
    
    /// 원형 배경 색상
    let backgroundColor: Color
    
    // MARK: - Init
    init(
        iconImage: Image = Image("Badge/lock"),
        size: CGFloat = 130,
        backgroundColor: Color = .gray030
    ) {
        self.iconImage = iconImage
        self.size = size
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
            
            iconImage
                .resizable()
                .scaledToFit()
                .frame(width: 46, height: 46)
        }
    }
}

#Preview {
    LockBadgeView()
}
