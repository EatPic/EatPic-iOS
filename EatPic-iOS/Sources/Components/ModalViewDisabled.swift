//
//  ModalView2.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/14/25.

import SwiftUI

/// 제목 + 설명 + 버튼 으로 이루어진 공통 모달 컴포넌트

/// - Parameters:
///   - messageTitle: 모달 제목 메시지의 내용을 담습니다
///   - messageDescription: 모달 설명 메시지의 내용을 담습니다
///   - messageColor : 모달 메시지의 색상입니다
///   - buttonText: 버튼의 텍스트입니다
///   - buttonColor: 버튼의 색상입니다
///   - buttonTextColor: 버튼의 텍스트 색상입니다
struct ModalViewDisabled: View {
    
    // MARK: - Property
    
    /// 모달 제목 메시지
    let messageTitle: String
    
    /// 모달 설명 메시지
    let messageDescription: String
    
    /// 메시지 색상
    let messageColor: Color
    
    /// 하단 버튼 텍스트
    let buttonText: String
    
    /// 하단 버튼 색상
    let buttonColor: Color
    
    /// 하단 버튼 텍스트 색상
    let buttonTextColor: Color

    
    // MARK: - Init
    init(
        messageTitle: String,
        messageDescription: String,
        messageColor: Color = .black,
        buttonText: String,
        buttonColor: Color = .green060,
        buttonTextColor: Color = .white
    ) {
        self.messageTitle = messageTitle
        self.messageDescription = messageDescription
        self.messageColor = messageColor
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
                /// 모달 제목 메시지
                Text(messageTitle)
                    .foregroundColor(messageColor)
                    .font(.koBold(size: 22))
                
                Spacer().frame(height: 36)
                
                /// 모달 설명 메시지
                Text(messageDescription)
                    .foregroundColor(messageColor)
                    .font(.koRegular(size: 16))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer().frame(height: 34)

                /// 모달 하단 버튼
                HStack {
                    Button(action: {
                        
                        // 모달 닫기 동작
                        
                    }) {
                        Text(buttonText)
                            .foregroundColor(buttonTextColor)
                            .frame(width: 230, height: 40)
                    }
                    .background(buttonColor)
                    .cornerRadius(10)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            .frame(width: 270)
            .background(.white)
            .cornerRadius(15)
        }
        
    }
}

#Preview() {
    ModalViewDisabled(
        messageTitle: "안내",
        messageDescription: "최대 3개까지 선택 가능합니다.",
        messageColor: .black,
        buttonText: "확인",
        buttonColor: .green060,
        buttonTextColor: .white
    )
}
