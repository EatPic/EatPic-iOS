//
//  ModalView3.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/15/25.
//

import SwiftUI

/// 텍스트 + 이미지 + 버튼으로 이루어진 공통 모달 컴포넌트

/// - Parameters:
///   - message: 모달 메시지의 내용을 담습니다
///   - messageColor : 모달 메시지의 색상입니다
///   - image : 모달 이미지입니다
///   - imageSize : 모달 이미지 사이즈입니다.
///   - buttonText: 버튼의 텍스트입니다
///   - buttonColor: 버튼의 색상입니다
///   - buttonTextColor: 버튼의 텍스트 색상입니다
struct ModalView3: View {
    
    
    // MARK: - Property
    
    /// 모달 메시지
    let message: String
    
    /// 메시지 색상
    let messageColor: Color
    
    /// 모달 이미지
    let image : Image
    
    /// 이미지 사이즈
    let imageSize: CGFloat
    
    /// 버튼 텍스트
    let buttonText: String
    
    /// 버튼 색상
    let buttonColor: Color
    
    /// 버튼 텍스트 색상
    let buttonTextColor: Color

    
    // MARK: - Init
    init(
        message: String,
        messageColor: Color = .black,
        image: Image,
        imageSize: CGFloat = 150,
        buttonText: String,
        buttonColor: Color = .green060,
        buttonTextColor: Color = .white
    ) {
        self.message = message
        self.messageColor = messageColor
        self.image = image
        self.imageSize = imageSize
        self.buttonText = buttonText
        self.buttonColor = buttonColor
        self.buttonTextColor = buttonTextColor
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            /// 모달 아래 어둡게 처리된 배경
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack {
                /// 모달 메시지
                Text(message)
                    .foregroundColor(messageColor)
                    .font(.koBold(size: 22))
                
                Spacer().frame(height: 22)
                
                /// 모달 이미지
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                
                Spacer().frame(height: 34)

                /// 모달 버튼
                HStack {
                    Button(action: {}) {
                        Text(buttonText)
                            .foregroundColor(buttonTextColor)
                            .frame(width: 230, height: 38)
                    }
                    .background(buttonColor)
                    .cornerRadius(10)
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .frame(width: 270)
            .background(.white)
            .cornerRadius(15)
        }
         
    }
}

#Preview() {
    ModalView3(
        message: "Pic 카드가 기록되었습니다",
        messageColor: .black,
        image: Image(systemName: "star.fill"),
        imageSize: 150,
        buttonText: "확인",
        buttonColor: .green060,
        buttonTextColor: .white
    )
}
