//
//  SignupPasswordView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/28/25.
//

import SwiftUI

/// 회원가입 비밀번호 입력 뷰
struct SignupPasswordView: View {
    // MARK: - Property
    
    @State var viewModel: SignupPasswordViewModel = .init(container: .init())
    
    /// 현재 포커싱된 입력 필드를 관리하는 FocusState
    @FocusState private var focus: SignUpFieldType?
   
    @EnvironmentObject private var container: DIContainer
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Spacer().frame(height: 32)
            topContents
            Spacer()
            nextButton
            Spacer().frame(height: 40)
        }
        .customCenterNavigationBar {
            Text("회원가입")
                .font(.dsTitle2)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - TopContents(회원가입 비밀번호 입력 뷰 상단 타이틀 및 텍스트 필드)
    
    /// 회원가입 비밀번호 입력 뷰 상단 콘텐츠
    private var topContents: some View {
        VStack(alignment: .leading, spacing: 32) {
            signupPasswordTitle
            signupPasswordTextField
            confirmPasswordTextField
        }
    }
    
    /// 회원가입 비밀번호 입력 뷰 타이틀
    private var signupPasswordTitle: some View {
        (
            Text("로그인에 사용할\n")
            + Text("비밀번호").foregroundStyle(Color.green060)
            + Text("를 입력해주세요")
        )
        .font(.dsTitle2)
        .multilineTextAlignment(.leading)
    }
    
    /// 회원가입 비밀번호 입력 텍스트 필드
    private var signupPasswordTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            FormTextField(
                fieldTitle: "비밀번호 입력",
                fieldType: SignUpFieldType.password,
                focusedField: $focus,
                currentField: .password,
                text: $viewModel.password,
                isValid: viewModel.isPasswordCountValid
            )
            
            // 유효성 검사 실패 시 하단에 메시지 노출
            if let error = viewModel.passwordErrorMessage {
                Text(error)
                    .font(.dsFootnote)
                    .foregroundStyle(Color.pink070)
            }
        }
    }
    
    /// 회원가입 비밀번호 확인 텍스트 필드
    private var confirmPasswordTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            FormTextField(
                fieldTitle: "비밀번호 확인",
                fieldType: SignUpFieldType.confirmPassword,
                focusedField: $focus,
                currentField: .confirmPassword,
                text: $viewModel.confirmPassword,
                isValid: viewModel.isPasswordConfirmed
            )
            
            // 유효성 검사 실패 시 하단에 메시지 노출
            if let error = viewModel.confirmPasswordErrorMessage {
                Text(error)
                    .font(.dsFootnote)
                    .foregroundStyle(Color.pink070)
            }
        }
    }
    
    // MARK: - BottomContents(화면 이동 버튼)
    
    /// 유효성 검사 통과시 버튼의 색상 바뀌도록 구현 예정
    private var nextButton: some View {
        PrimaryButton(
            color: viewModel.isPasswordValid ? .green060 : .gray020,
            text: "다음",
            font: .dsTitle3,
            textColor: viewModel.isPasswordValid ? .white : .gray040,
            height: 50,
            cornerRadius: 10,
            action: {
                // 비밀번호 유효성검사 통과시 화면 이동
                if viewModel.isPasswordValid {
                    container.router.push(.signupNicknameView)
                }
            })
    }
}

#Preview {
    SignupPasswordView()
}
