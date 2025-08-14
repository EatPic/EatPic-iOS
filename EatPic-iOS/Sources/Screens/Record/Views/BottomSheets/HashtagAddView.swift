//
//  HashTagAdd.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

struct HashtagAddView: View {
    @Binding var hashtagInput: String
    let isEnabled: Bool
    let onAddHashtag: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 9) {
                TextField("최대 5글자 입력", text: $hashtagInput)
                    .font(.dsBody)
                    .foregroundStyle(Color.gray080)
                    .padding(9.5)
                    .background(Color.white000)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .lineLimit(1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isEnabled ? Color.green060 : Color.red050,
                                lineWidth: 1
                            )
                    )
                
                PrimaryButton(
                    color: isEnabled ? .green060 : .gray040,
                    text: "추가",
                    font: .dsHeadline,
                    textColor: isEnabled ? .white : .gray060,
                    width: 64,
                    height: 40,
                    cornerRadius: 10
                ) {
                    onAddHashtag()
                }
                .disabled(!isEnabled)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    HashtagAddView(
        hashtagInput: .constant(""),
        isEnabled: true,
        onAddHashtag: {}
    )
}
