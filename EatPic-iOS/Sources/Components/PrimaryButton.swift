//
//  PrimaryButton.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import SwiftUI

/// 앱 전역적으로 재사용 가능한 메인 버튼
struct PrimaryButton: View {
    
    // MARK: - Property
    
    /// 버튼 배경 색상
    let color: Color
    
    /// 버튼에 표시되는 텍스트
    let text: String
    
    /// 텍스트 폰트
    let font: Font
    
    /// 텍스트 색상
    let textColor: Color
    
    /// 버튼 높이
    let height: CGFloat
    
    /// 모서리 둥근 정도
    let cornerRadius: CGFloat
    
    /// 버튼이 눌렸을 때 실행되는 클로저
    let action: () -> Void
    
    /// 버튼 내부에서 사용하는 레이아웃 상수
    fileprivate enum PrimaryButtonConstants {
        static let buttonHeight = 50
        static let cornerRadius = 10
    }
    
    // MARK: - Init
    
    /// Primary Button 생성자
    /// - Parameters:
    ///   - color: 버튼 배경색
    ///   - text: 버튼 내부 텍스트 내용
    ///   - font: 버튼 내부 텍스트 폰트
    ///   - textColor: 버튼 내부 텍스트 색상
    ///   - height: 버튼 높이
    ///   - action: 버튼 클릭 시 실행할 동작
    init(
        color: Color,
        text: String,
        font: Font,
        textColor: Color,
        height: CGFloat,
        cornerRadius: CGFloat,
        action: @escaping () -> Void
    ) {
        self.color = color
        self.text = text
        self.font = font
        self.textColor = textColor
        self.height = height
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                // 배경: 둥근 사각형 모양
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                
                // 버튼 텍스트
                    Text(text)
                    .font(font)
                    .foregroundStyle(textColor)
            }
        })
    }
}

#Preview {
    PrimaryButton(
        color: .green060,
        text: "로그인",
        font: .koRegular(size: 20),
        textColor: Color.white,
        height: 50,
        cornerRadius: 10,
        action: {print("로그인하기")})
}
