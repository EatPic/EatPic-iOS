//
//  ModalViewTwoBtn.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/14/25.
//

import SwiftUI

/// 안내 + 버튼 두개로 이루어진 공통 모달 컴포넌트

/// - Parameters:
///   - message: 모달 메시지의 내용을 담습니다.
///   - messageColor : 모달 메시지의 색상입니다;
///   - leftButtonText: 왼쪽 버튼의 텍스트입니다
///   - rightButtonText: 오른쪽 버튼의 텍스트입니다
///   - leftButtonAction: 왼쪽 버튼의 액션입니다
///   - rightButtonAction: 오른쪽 버튼의 액션입니다
struct ModalViewTwoBtn: View {
    
    // MARK: - Property
    
    /// 모달 메시지
    let message: String
    
    /// 메시지의 색상
    let messageColor: Color
    
    /// 하단 왼쪽 버튼 텍스트
    let leftButtonText: String
    
    /// 하단 오른쪽 버튼 텍스트
    let rightButtonText: String
    
    /// 왼쪽 버튼의 액션
    let leftButtonAction: () -> Void
    
    /// 오른쪽 버튼의 액션
    let rightButtonAction: () -> Void
    
    // MARK: - Init
    init(
        message: String,
        messageColor: Color = .black,
        leftButtonText: String,
        rightButtonText: String,
        leftButtonAction: @escaping () -> Void,
        rightButtonAction: @escaping () -> Void

    ) {
        self.message = message
        self.messageColor = messageColor
        self.leftButtonText = leftButtonText
        self.rightButtonText = rightButtonText
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
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
                            .font(.dsHeadline)
                
                Spacer().frame(height: 41)
 
                /// 모달 버튼 두개
                HStack {

                    /// 부정 버튼
                    PrimaryButton(
                        color: .gray020,
                        text: leftButtonText,
                        font: .dsBold15,
                        textColor: .black,
                        width: 130,
                        height: 38,
                        cornerRadius: 9,
                        action: leftButtonAction
                    )
                    
                    Spacer().frame(width: 16)
                    
                    /// 긍정 버튼
                    PrimaryButton(
                        color: .green060,
                        text: rightButtonText,
                        font: .dsBold15,
                        textColor: .white,
                        width: 130,
                        height: 38,
                        cornerRadius: 9,
                        action: rightButtonAction
                    )
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ModalViewTwoBtn(
        message: "기록한 Pic 카드를 삭제하시겠습니까?",
        messageColor: .black,
        leftButtonText: "아니오",
        rightButtonText: "예",
        leftButtonAction: {
            print("아니오 눌림")
        },
        rightButtonAction: {
            print("예 눌림")
        }
    )
}
