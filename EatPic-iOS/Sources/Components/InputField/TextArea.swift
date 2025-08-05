//
//  TextArea.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/5/25.
//

import SwiftUI

struct TextArea: View {
    @Binding var text: String
    
    init(
        text: Binding<String>
    ) {
        self._text = text
    }
    
    var body: some View {
        // TextField
        TextField("", text: $text)
            .foregroundColor(.gray)
            .font(.dsBody)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .lineLimit(nil) // 줄 제한 없음
    }
}

#Preview {
    @Previewable @State var text = ""
    TextArea(text: $text)
}
