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
///   - leftBtnText: 왼쪽 버튼의 텍스트입니다
///   - rightBtnText: 오른쪽 버튼의 텍스트입니다
///   - leftBtnAction: 왼쪽 버튼의 액션입니다
///   - rightBtnAction: 오른쪽 버튼의 액션입니다
///   - rightBtnColor: 오른쪽 버튼의 배경 색상입니다
struct DecisionModalView: View {
    
    // MARK: - Property
    
    /// 모달 메시지
    let message: String
    
    /// 메시지의 색상
    let messageColor: Color
    
    /// 하단 왼쪽 버튼 텍스트
    let leftBtnText: String
    
    /// 하단 오른쪽 버튼 텍스트
    let rightBtnText: String
    
    /// 오른쪽 버튼의 배경 색상
    let rightBtnColor: Color
    
    /// 왼쪽 버튼의 액션
    let leftBtnAction: () -> Void
    
    /// 오른쪽 버튼의 액션
    let rightBtnAction: () -> Void
    
    // MARK: - Init
    init(
        message: String,
        messageColor: Color = .black,
        leftBtnText: String,
        rightBtnText: String,
        rightBtnColor: Color = .green060,
        leftBtnAction: @escaping () -> Void,
        rightBtnAction: @escaping () -> Void

    ) {
        self.message = message
        self.messageColor = messageColor
        self.leftBtnText = leftBtnText
        self.rightBtnText = rightBtnText
        self.rightBtnColor = rightBtnColor
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
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
                        text: leftBtnText,
                        font: .dsBold15,
                        textColor: .black,
                        width: 130,
                        height: 38,
                        cornerRadius: 9,
                        action: leftBtnAction
                    )
                    
                    Spacer().frame(width: 16)
                    
                    /// 긍정 버튼
                    PrimaryButton(
                        color: rightBtnColor,
                        text: rightBtnText,
                        font: .dsBold15,
                        textColor: .white,
                        width: 130,
                        height: 38,
                        cornerRadius: 9,
                        action: rightBtnAction
                    )
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    DecisionModalView(
        message: "기록한 Pic 카드를 삭제하시겠습니까?",
        messageColor: .black,
        leftBtnText: "아니오",
        rightBtnText: "예",
        rightBtnColor: .green060,
        leftBtnAction: {
            print("아니오 눌림")
        },
        rightBtnAction: {
            print("예 눌림")
        }
    )
}
