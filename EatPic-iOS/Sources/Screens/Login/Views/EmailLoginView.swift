//
//  EmailLoginView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/26/25.
//

import SwiftUI

struct EmailLoginView: View {
    // MARK: - Property
    
    /// 로그인 기능 및 상태를 관리하는 ViewModel
    @State var viewModel: LoginViewModel
    
    /// 현재 포커싱된 입력 필드를 관리하는 FocusState
    @FocusState private var focus: SignUpFieldType?
    
    @EnvironmentObject private var container: DIContainer

    /// DIContainer와 앱 흐름 ViewModel(AppFlowViewModel)을 주입받아 초기화
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.viewModel = .init(container: container, appFlowViewModel: appFlowViewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            Spacer().frame(height: 49)
            topContents
            
            middleContents
            Spacer()
        }
        .padding(.horizontal, 16)
        .customCenterNavigationBar {
            Text("이메일로 로그인")
                .font(.dsTitle2)
        }
    }
    
    // MARK: - topContents(이메일, 비밀번호 텍스트 필드)
    
    private var topContents: some View {
        VStack(alignment: .leading, spacing: 32) {
            emailLoginField
        }
    }
    
    /// 이메일 텍스트필드 및 타이틀
    private var emailLoginField: some View {
        VStack(alignment: .leading, spacing: 32) {
            FormTextField(
                fieldTitle: "이메일",
                fieldType: SignUpFieldType.loginId,
                focusedField: $focus,
                currentField: .loginId,
                text: $viewModel.email,
                isValid: true
            )
            
            /// 비밀번호 텍스트필드 및 타이틀
            FormTextField(
                fieldTitle: "비밀번호",
                fieldType: SignUpFieldType.loginPassword,
                focusedField: $focus,
                currentField: .loginPassword,
                text: $viewModel.password,
                isValid: true
            )
        }
    }

    // MARK: - 로그인버튼 및 회원가입하기 버튼
    
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: 24) {
            loginButton
            signupButton
        }
    }
    
    private var loginButton: some View {
        VStack(alignment: .leading, spacing: 8) {
            PrimaryButton(
                color: viewModel.fieldsNotEmpty ? .green060 :.gray020,
                text: "로그인",
                font: .dsTitle3,
                textColor: viewModel.fieldsNotEmpty ? .white : .gray040,
                height: 50,
                cornerRadius: 10,
                action: {
                    // MainTab으로 연결
                    Task {
                        await viewModel.emailLogin()
                    }
                })
            
            /// 유효성 검사 실패시 에러 메시지
            if let error = viewModel.loginError {
                Text(error)
                    .font(.dsFootnote)
                    .foregroundStyle(Color.pink070)
            }
        }
    }
    
    private var signupButton: some View {
        HStack(alignment: .center, spacing: 8) {
            Spacer()
                
            Text("아직 계정이 없으신가요?")
                .font(.dsSubhead)
                .foregroundStyle(Color.gray060)
            
            Button(action: {
                // 회원가입 플로우 시작 시점에 단 한 번 생성/보관
                _ = container.getSignupFlowVM() // 생성 or 기존 반환 (싱글턴처럼)
                container.router.push(.signUpEmailView)
            }, label: {
                Text("회원가입 하기")
                    .font(.dsSubhead)
                    .foregroundStyle(Color.green060)
            })
            Spacer()
        }
    }
}
    
struct EmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmailLoginView(container: .init(), appFlowViewModel: .init())
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE 3rd")

            EmailLoginView(container: .init(), appFlowViewModel: .init())
                .previewDevice("iPhone 16 Pro Max")
                .previewDisplayName("iPhone 16 Pro Max")
        }
    }
}
