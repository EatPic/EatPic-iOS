//
//  TextAreaView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/17/25.
//

import SwiftUI

/// 높이는 동적으로 조절 가능한 TextAreaView
/// - Parameters:
///   - text: 바인딩된 텍스트 값입니다.
///   - height: TextArea의 높이입니다.
///   - backgroundColor: TextArea의 배경 색상입니다.
///   - borderColor: TextArea의 테두리 색상입니다.
///   - textColor: 입력되는 텍스트의 색상입니다.
struct TextAreaView: View {
    
    // MARK: - Property
    /// 바인딩된 텍스트 값
    @Binding var text: String
    /// placeholder 텍스트
    let placeholder: String
    /// TextArea의 높이
    let height: CGFloat
    /// TextArea의 배경 색상
    let backgroundColor: Color
    /// TextArea의 테두리 색상
    let borderColor: Color
    /// 텍스트의 색상
    let textColor: Color
    
    // MARK: - Init
    init(
        text: Binding<String>,
        placeholder: String = "",
        height: CGFloat,
        backgroundColor: Color = .white,
        borderColor: Color = .gray040,
        textColor: Color = .gray080
    ) {
        self._text = text
        self.placeholder = placeholder
        self.height = height
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.textColor = textColor
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 테두리
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .overlay(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                }
            
            // 텍스트 입력
            TextEditor(text: $text)
                .foregroundColor(textColor)
                .font(.dsBody)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.clear)
                .scrollContentBackground(.hidden)
            
            // Placeholder
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray050)
                    .font(.dsBody)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    @Previewable @State var myMemo = ""
    
    TextAreaView(
        text: $myMemo,
        placeholder: "메모를 입력하세요",
        height: 140
    )
}
