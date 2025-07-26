//
//  LoginView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/23/25.
//

import SwiftUI

struct LoginView: View {
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 31) {
            Spacer()
            topContents // 로고와 타이틀
            Spacer()
            middleContents // 소셜 로그인 버튼
            bottomContents // 텍스트와 하단 회원가입 버튼
            Spacer()
        }
    }
    
    // MARK: - Top Contents (로고와 타이틀)
    
    /// 로그인 화면 상단 컨텐츠 VStack
    private var topContents: some View {
        VStack(alignment: .center, spacing: 35) {
            topTitleContents
            topLogoImage
        }
    }
    
    /// 상단 타이틀
    private var topTitleContents: some View {
        Text("한장의 식사, 매일의 기록")
            .font(.dsTitle1)
            .foregroundStyle(Color.black)
    }
    
    /// 상단 로고
    private var topLogoImage: some View {
        Image(.logo)
            .resizable()
            .frame(width: 258, height: 258)
    }
    
    // MARK: - Middle Contents (소셜 로그인 버튼)
    
    /// 중간 컨텐츠
    private var middleContents: some View {
        VStack(alignment: .center, spacing: 22) {
            socialLoginButton
        }
    }
    
    /// 카카오 및 애플 로그인 버튼
    @ViewBuilder
    private var socialLoginButton: some View {
        let items: [SocialLoginItem] = [
            .init(type: .kakao, action: {
                // 카카오 로그인 기능 구현 예정
            }),
            .init(type: .apple, action: {
                // 애플 로그인 기능 구현 예정
            })
        ]
        
        ForEach(items, id: \.id) { button in
            Button(action: {
                button.action()
            }, label: {
                button.type.image
            })
        }
    }

    // MARK: - Bottom Contents
    
    private var bottomContents: some View {
        VStack(alignment: .center, spacing: 31) {
            middleTextDivider
            bottomButtonContents
        }
    }
    
    private var middleTextDivider: some View {
        Text("또는")
            .font(.dsCallout)
            .foregroundStyle(Color.gray060)
    }
    private var bottomButtonContents: some View {
        HStack(spacing: 20) {
            emailSignupButton
            emailLoginButton
        }
    }
    
    private var emailSignupButton: some View {
        PrimaryButton(
            color: .white,
            text: "이메일로 회원가입",
            font: .dsSubhead,
            textColor: .gray060,
            width: 170, height: 50,
            cornerRadius: 10,
            action: {
            // 네비게이션 액션 구현 예정
        })
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray060, lineWidth: 1)
        )
    }
    
    private var emailLoginButton: some View {
        PrimaryButton(
            color: .white,
            text: "이메일로 로그인",
            font: .dsSubhead,
            textColor: .gray060,
            width: 170, height: 50,
            cornerRadius: 10,
            action: {
            // 네비게이션 액션 구현 예정
        })
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray060, lineWidth: 1)
        )
    }
}

#Preview {
    LoginView()
}
