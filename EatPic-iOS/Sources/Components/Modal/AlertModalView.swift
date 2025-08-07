//
//  ModalViewDisabled.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/14/25.

import SwiftUI

/// 제목 + 설명 + 버튼 으로 이루어진 공통 모달 컴포넌트
/// - Parameters:
///   - messageTitle: 모달 제목 메시지의 내용을 담습니다
///   - messageDescription: 모달 설명 메시지의 내용을 담습니다
///   - messageColor : 모달 메시지의 색상입니다
///   - btnText : 버튼 텍스트입니다
///   - btnAction: 버튼 클릭 시 실행할 액션입니다
struct AlertModalView: View {
    
    // MARK: - Property
    
    /// 모달 제목 메시지
    let messageTitle: String
    
    /// 모달 설명 메시지
    let messageDescription: String
    
    /// 메시지 색상
    let messageColor: Color
    
    /// 버튼 텍스트
    let btnText: String
    
    /// 버튼 액션
    let btnAction: () -> Void
    
    // MARK: - Init
    init(
        messageTitle: String,
        messageDescription: String,
        messageColor: Color = .black,
        btnText: String,
        btnAction: @escaping () -> Void
    ) {
        self.messageTitle = messageTitle
        self.messageDescription = messageDescription
        self.messageColor = messageColor
        self.btnText = btnText
        self.btnAction = btnAction
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
                    .foregroundStyle(messageColor)
                    .font(.dsTitle3)
                
                Spacer().frame(height: 36)
                
                /// 모달 설명 메시지
                Text(messageDescription)
                    .foregroundStyle(messageColor)
                    .font(.dsCallout)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer().frame(height: 34)

                PrimaryButton(
                    color: .green060,
                    text: btnText,
                    font: .dsBold15,
                    textColor: .white,
                    width: 230,
                    height: 40,
                    cornerRadius: 10,
                    action: btnAction
                )
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            .frame(width: 270)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    AlertModalView(
        messageTitle: "안내",
        messageDescription: "최대 3개까지 선택 가능합니다.",
        messageColor: .black,
        btnText: "확인btnText",
        btnAction: {
            print("확인 버튼 눌림")
        }
    )
}
