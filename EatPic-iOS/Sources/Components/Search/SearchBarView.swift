//
//  SearchBarView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/19/25.
//

import SwiftUI

/// 공용 검색 바 UI 컴포넌트입니다.
/// - 검색어 입력이 가능하며, 입력값은 외부에서 @Binding으로 제어할 수 있습니다.
/// - 플레이스홀더, 좌측 검색 아이콘, 입력 삭제 버튼(옵션), 배경 색상 및 테두리를 커스터마이징할 수 있습니다.
/// - 로그인/회원가입, 피드 검색, 해시태그 검색 등 다양한 검색 상황에서 재사용할 수 있습니다.
struct SearchBarView: View {
    // MARK: - Property
    /// 검색 텍스트 바인딩 (외부 ViewModel 또는 상태에서 제어)
    @Binding var text: String
    
    /// 플레이스홀더 텍스트 (기본값: "계정 또는 해시태그 검색")
    var placeholder: String
    
    /// 삭제 버튼 표시 여부 (기본값: true)
    var showsDeleteButton: Bool
    
    /// 배경 색상 (기본값: Color.gray020)
    var backgroundColor: Color
    
    /// 테두리 색상 (nil일 경우 테두리 없음)
    var strokeColor: Color?
    
    /// 입력 완료 시 호출되는 콜백
    var onSubmit: (() -> Void)?
    
    /// 텍스트 변경 시 호출되는 콜백
    var onChange: ((String) -> Void)?
    
    // MARK: - Init
    init(
        text: Binding<String>,
        placeholder: String,
        showsDeleteButton: Bool,
        backgroundColor: Color,
        strokeColor: Color?,
        onSubmit: (() -> Void)?,
        onChange: ((String) -> Void)?
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showsDeleteButton = showsDeleteButton
        self.backgroundColor = backgroundColor
        self.strokeColor = strokeColor
        self.onSubmit = onSubmit
        self.onChange = onChange
    }
    
    // MARK: - body
    var body: some View {
        HStack(spacing: 16) {
            // 좌측 검색 아이콘
            Image("icon_search")
            
            // 텍스트 필드와 플레이스홀더
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
            
            // 입력 삭제 버튼 (옵션)
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
                .fill(backgroundColor)
                .overlay(alignment: .center) {
                    Group {
                        if let strokeColor {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(strokeColor, lineWidth: 1)
                        }
                    }
                }
        )
    }
}

// MARK: - Preview
#Preview {
    StatefulPreviewWrapper("") {
        SearchBarView(
            text: $0,
            placeholder: "닉네임 또는 아이디로 검색",
            showsDeleteButton: false,
            backgroundColor: .gray020,
            strokeColor: nil,
            onSubmit: {
                print("Submitted")
            },
            onChange: {
                print("Changed to \($0)")
            }
        )
    }
}

// MARK: - Preview 바인딩 지원 유틸
/// 프리뷰에서 바인딩이 필요한 컴포넌트를 테스트할 수 있도록 도와주는 유틸리티
fileprivate struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView
    
    init(
        _ initialValue: Value,
        content: @escaping (Binding<Value>) -> some View
    ) {
        _value = State(initialValue: initialValue)
        self.content = { binding in AnyView(content(binding)) }
    }
    
    var body: some View {
        content($value)
    }
}
