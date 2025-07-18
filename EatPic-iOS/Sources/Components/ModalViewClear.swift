//
//  ModalViewClear.swift
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
///   - imageSize : 모달 이미지 사이즈입니다
///   - buttonText : 버튼 텍스트입니다
///   - buttonAction: 버튼 클릭 시 실행할 액션입니다
struct ModalViewClear: View {
    
    // MARK: - Property
    
    /// 모달 메시지
    let message: String
    
    /// 메시지 색상
    let messageColor: Color
    
    /// 모달 이미지
    let image: Image
    
    /// 이미지 사이즈
    let imageSize: CGFloat
    
    /// 버튼 텍스트
    let buttonText: String
    
    /// 버튼 액션
    let buttonAction: () -> Void
    
    // MARK: - Init
    init(
        message: String,
        messageColor: Color = .black,
        image: Image = Image("Modal/itcong"),
        imageSize: CGFloat = 150,
        buttonText: String,
        buttonAction: @escaping () -> Void
    ) {
        self.message = message
        self.messageColor = messageColor
        self.image = image
        self.imageSize = imageSize
        self.buttonText = buttonText
        self.buttonAction = buttonAction
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
//                    .font(.koBold(size: 22))
                    .font(.dsHeadline)
                
                Spacer().frame(height: 22)
                
                /// 모달 이미지
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                
                Spacer().frame(height: 34)

                PrimaryButton(
                    color: .green060,
                    text: buttonText,
                    font: .dsHeadline,
                    textColor: .white,
                    width: 230,
                    height: 38,
                    cornerRadius: 10,
                    action: buttonAction
                )
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .frame(width: 270)
            .background(.white)
            .cornerRadius(15)
        }
         
    }
}

#Preview {
    ModalViewClear(
        message: "Pic 카드가 기록되었습니다",
        image: Image("Modal/itcong"),
        imageSize: 150,
        buttonText: "확인",
        buttonAction: {
            print("확인 버튼 눌림")
        }
    )
}
