//
//  SignupNicknameView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/28/25.
//

import SwiftUI

struct SignupNicknameView: View {
    // MARK: - Property

    /// 유효성검사 로직 맡고있는 ViewModel
    @State var viewModel: SignUpNicknameViewModel = .init()

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
            Text("정보입력")
                .font(.dsTitle2)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - TopContents(회원가입 닉네임 정보입력 뷰 상단 타이틀 및 텍스트 필드)

    /// 회원가입 닉네임 정보입력 상단 콘텐츠
    private var topContents: some View {
        VStack(alignment: .leading, spacing: 32) {
            signupStepTitle
            signupNicknameTitle
            signupNicknameTextField
        }
    }
    
    /// 회원가입 닉네임 정보입력 뷰 Step 타이틀
    private var signupStepTitle: some View {
        (
        Text("STEP 1 ")
            .foregroundStyle(Color.green060)
        + Text("/ 3")
        )
        .font(.dsTitle3)
    }
    
    /// 회원가입 닉네임 정보입력 뷰 타이틀
    private var signupNicknameTitle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("사용할 닉네임을 입력해주세요")
                .font(.dsTitle2)

            Text("추후에 언제든지 변경할 수 있어요")
                .font(.dsFootnote)
                .foregroundStyle(Color.gray060)
        }
    }
    /// 회원가입 닉네임 정보입력 뷰 텍스트 필드
    private var signupNicknameTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            FormTextField(
                fieldType: SignUpFieldType.nickname,
                focusedField: $focus,
                currentField: .nickname,
                text: $viewModel.nickname,
                isValid: viewModel.isNicknameValid
            )
            
            /// 유효성 검사 실패시 에러 메시지
            if let error = viewModel.nicknameErrorMessage {
                Text(error)
                    .font(.dsFootnote)
                    .foregroundStyle(Color.red050)
            }
        }
    }

    // MARK: - BottomContents(화면 이동 버튼)

    /// 유효성 검사 통과시 버튼의 색상 바뀌도록 구현 예정
    private var nextButton: some View {
        PrimaryButton(
            color: viewModel.isNicknameValid ? .green060 : .gray020,
            text: "다음",
            font: .dsTitle3,
            textColor: viewModel.isNicknameValid ? .white : .gray040,
            height: 50,
            cornerRadius: 10,
            action: {
                /// 닉네임 유효성검사 통과시 화면 이동 구현 예정
                if viewModel.isNicknameValid {
                    container.router.push(.signupIdView)
                }
            })
    }
}

#Preview {
    SignupNicknameView()
}
