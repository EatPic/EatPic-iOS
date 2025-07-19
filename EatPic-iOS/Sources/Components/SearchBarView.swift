//
//  SearchBarView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/19/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        
        HStack(spacing: 16) {
            Image("icon_search")
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("계정 또는 해시태그 검색")
                        .font(.dsBody)
                        .foregroundStyle(Color.gray050)
                }
                TextField("", text: $text)
                    .font(.dsBody)
                    .foregroundStyle(Color.gray080)
                    .tint(Color.gray080)
            }
            
            Spacer()
            
            Button {
                text = ""
            } label: {
                Image("icon_delete")
            }
        }
        .padding(.vertical, 8)
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .frame(width: .infinity, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray020)
                .stroke(Color.gray080, lineWidth: 1)
        )
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper("eatpic") { binding in
            SearchBarView(text: binding)
        }
    }
}

/// 바인딩을 테스트용으로 프리뷰에 주입하기 위한 Wrapper
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
