//
//  HashTagAdd.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

struct HashtagAddView: View {
    @State private var hashtagInput: String = ""
    
    var body: some View {
        VStack {
//            TopBanner()
//            
//            Spacer().frame(height: 50)
            
            HStack {
                TextAreaView(
                    text: $hashtagInput,
                    placeholder: "최대 5글자 입력",
                    height: 40
                )
                
                Spacer().frame(width: 9)
                
                PrimaryButton(
                    color: .green060,
                    text: "추가",
                    font: .dsHeadline,
                    textColor: .white,
                    width: 64,
                    height: 40,
                    cornerRadius: 10
                ) {
                    // TODO: 해시태그 추가 액션
                }
                
                Spacer()
            }
            .padding(.horizontal, 19)
        }
    }
}
//
//private struct TopBanner: View {
//    var body: some View {
//        VStack {
//            ZStack {
//                Text("해시태그 추가")
//                    .font(.dsTitle2)
//
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        // TODO: RecomPicCardView로 Navigation
//                    }, label: {
//                        Image("Record/btn_home_close")
//                    })
//                }
//            }
//            .padding(.horizontal, 19)
//        }
//    }
//}

#Preview {
    HashtagAddView()
}
