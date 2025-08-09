//
//  HashTagAdd.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

struct HashtagAddView: View {
    @Binding var hashtagInput: String
    let isAddButtonEnabled: Bool
    let onAddHashtag: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            TopBanner(onClose: onClose)
            
//            Spacer().frame(height: 78)
//            Spacer().frame(height: 78)
            Spacer()
            
            HStack {
                TextAreaView(
                    text: $hashtagInput,
                    placeholder: "최대 5글자 입력",
                    height: 40
                )
                
                Spacer().frame(width: 9)
                
                PrimaryButton(
                    color: isAddButtonEnabled ? .green060 : .gray040,
                    text: "추가",
                    font: .dsHeadline,
                    textColor: isAddButtonEnabled ? .white : .gray060,
                    width: 64,
                    height: 40,
                    cornerRadius: 10
                ) {
                    onAddHashtag()
                }
                .disabled(!isAddButtonEnabled)
            }
            .padding(.horizontal, 19)
        }
    }
}

private struct TopBanner: View {
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Text("해시태그 추가")
                    .font(.dsTitle2)

                HStack {
                    Spacer()
                    Button(action: {
                        onClose()
                    }, label: {
                        Image("Record/btn_home_close")
                    })
                }
            }
            .padding(.horizontal, 19)
        }
    }
}

#Preview {
    HashtagAddView(
        hashtagInput: .constant(""),
        isAddButtonEnabled: false,
        onAddHashtag: {},
        onClose: {}
    )
}
