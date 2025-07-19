//
//  SearchBarView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/19/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    
    var placeholder: String
    
    var showsDeleteButton: Bool
    
    var backgroundColor: Color
    
    var strokeColor: Color?
    
    var onSubmit: (() -> Void)?
    
    var onChange: ((String) -> Void)?
    
    init(
        text: Binding<String>,
        placeholder: String = "계정 또는 해시태그 검색",
        showsDeleteButton: Bool = true,
        backgroundColor: Color = Color.gray020,
        strokeColor: Color? = Color.gray080,
        onSubmit: (() -> Void)? = nil,
        onChange: ((String) -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showsDeleteButton = showsDeleteButton
        self.backgroundColor = backgroundColor
        self.strokeColor = strokeColor
        self.onSubmit = onSubmit
        self.onChange = onChange
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image("icon_search")
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.dsBody)
                        .foregroundStyle(Color.gray050)
                }
                TextField("", text: $text)
                    .font(.dsBody)
                    .foregroundStyle(Color.gray080)
                    .tint(Color.gray080)
                    .onSubmit {
                        onSubmit?()
                    }
                    .onChange(of: text) { newValue in
                        onChange?(newValue)
                    }
            }
            
            Spacer()
            
            if showsDeleteButton && !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image("icon_delete")
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .frame(width: .infinity, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray020)
                .overlay(
                    Group {
                        if let strokeColor {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(strokeColor, lineWidth: 1)
                        }
                    }
                )
        )
    }
}

#Preview {
    StatefulPreviewWrapper("") {
        SearchBarView(
            text: $0,
            onSubmit: { print("Submitted") },
            onChange: { print("Changed to: \($0)") }
        )
    }
}

/// 프리뷰에서 바인딩이 필요한 컴포넌트를 테스트할 수 있도록 도와주는 유틸리티
struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView
    
    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> some View) {
        _value = State(initialValue: initialValue)
        self.content = { binding in AnyView(content(binding)) }
    }
    
    var body: some View {
        content($value)
    }
}
