//
//  SignupComplementView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/1/25.
//

import SwiftUI

struct SignupComplementView: View {
    // MARK: - Property

    @EnvironmentObject private var container: DIContainer
    @State var viewModel: SignupFlowViewModel = .init(container: .init())

    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 83)
            signupComplementTitle
            Spacer().frame(height: 52)
            logoImage
            Spacer().frame(height: 165)
            startButton
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    // MARK: - 회원가입 완료 Contents

    /// 회원가입 완료 타이틀
    private var signupComplementTitle: some View {
        (
            Text("EatPic")
                .foregroundStyle(Color.green060)
            + Text("에 오신 걸 환영해요:)\n")
            + Text("이제 식사를 기록하고,\n")
            + Text("공유해보세요.")
        )
        .font(.dsTitle1)
        .multilineTextAlignment(.leading)
    }
    
    /// 앱 로고
    private var logoImage: some View {
        HStack {
            Spacer()
            Image(.logo)
                .resizable()
                .frame(width: 258, height: 258)
            Spacer()
        }
    }

    /// 회원가입 완료 버튼
    private var startButton: some View {
        PrimaryButton(
            color: .green060,
            text: "지금 시작하기",
            font: .dsTitle3,
            textColor: .white,
            height: 50,
            cornerRadius: 10,
            action: {
                Task {
                    do {
                        try await viewModel.fetchAuth() // 성공 시에만 다음 줄 호출
                        await MainActor.run { container.router.popToRoot() }
                    } catch {
                        print("회원가입 실패")
                    }
                }
            })
    }
}

#Preview {
    SignupComplementView()
}
