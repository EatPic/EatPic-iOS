//
//  ModalView1.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/14/25.
//

import SwiftUI

/// 제목 + 설명 + 버튼 으로 이루어진 공통 모달 컴포넌트

/// - Parameters:
///   - message: 모달 메시지의 내용을 담습니다.
///   - messageColor : 모달 메시지의 색상입니다;
///   - leftButtonText: 왼쪽 버튼의 텍스트입니다
///   - leftButtonColor: 왼쪽 버튼의 색상입니다
///   - leftButtonTextColor: 왼쪽 버튼의 텍스트 색상입니다
///   - leftButtonText: 오른쪽 버튼의 텍스트입니다
///   - leftButtonColor: 오른쪽 버튼의 색상입니다
///   - leftButtonTextColor: 오른쪽 버튼의 텍스트 색상입니다
struct ModalView1: View {
    
    // MARK: - Property
    
    /// 모달 메시지
    let message: String
    
    /// 메시지의 색상
    let messageColor: Color
    
    /// 하단 왼쪽 버튼 텍스트
    let leftButtonText: String
    
    /// 하단 왼쪽 버튼 색상
    let leftButtonColor: Color
    
    /// 하단 왼쪽 버튼 텍스트 색상
    let leftButtonTextColor: Color
    
    /// 하단 오른쪽 버튼 텍스트
    let rightButtonText: String
    
    /// 하단 오른쪽 버튼 색상
    let rightButtonColor: Color
    
    /// 하단 오른쪽 버튼 텍스트 색상
    let rightButtonTextColor: Color
    
    
    // MARK: - Init
    init(
        message: String,
        messageColor: Color = .black,
        leftButtonText: String,
        leftButtonColor: Color = .gray020,
        leftButtonTextColor: Color = .white,
        rightButtonText: String,
        rightButtonColor: Color = .green060,
        rightButtonTextColor: Color = .white
    ) {
        self.message = message
        self.messageColor = messageColor
        self.leftButtonText = leftButtonText
        self.leftButtonColor = leftButtonColor
        self.leftButtonTextColor = leftButtonTextColor
        self.rightButtonText = rightButtonText
        self.rightButtonColor = rightButtonColor
        self.rightButtonTextColor = rightButtonTextColor
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
                    .font(.koBold(size: 17))
                
                Spacer().frame(height:41)
 
                /// 모달 버튼 두개
                HStack {
                    /// 부정 버튼
                    Button(action: {}) {
                        Text(leftButtonText)
                            .foregroundColor(leftButtonTextColor)
                            .font(.koBold(size: 15))
                            .frame(width: 130, height: 38)
                    }
                    .background(leftButtonColor)
                    .cornerRadius(9)

                    Spacer().frame(width: 16)
                    
                    /// 긍정 버튼
                    Button(action: {}) {
                        Text(rightButtonText)
                            .foregroundColor(rightButtonTextColor)
                            .font(.koBold(size: 15))
                            .frame(width: 130, height: 38)
                    }
                    .background(rightButtonColor)
                    .cornerRadius(9)
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

#Preview() {
    ModalView1(
        message: "기록한 Pic 카드를 삭제하시겠습니까?",
        messageColor: .black,
        leftButtonText: "아니오",
        leftButtonColor: .gray020,
        leftButtonTextColor: .black,
        rightButtonText: "예",
        rightButtonColor: .green060,
        rightButtonTextColor: .white
    )
}
