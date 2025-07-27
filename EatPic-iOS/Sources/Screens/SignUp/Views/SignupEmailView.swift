//
//  signupEmailView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/26/25.
//

import SwiftUI

struct SignupEmailView: View {
    // MARK: - Property
    
    /// 로그인 기능 및 상태를 관리하는 ViewModel
    @State var viewModel: SignUpViewModel
    
    /// 현재 포커싱된 입력 필드를 관리하는 FocusState
    @FocusState private var focus: SignUpFieldType?
   
    @EnvironmentObject private var container: DIContainer
    
    // MARK: - Init
    /// 기본 생성자: 내부에서 ViewModel 인스턴스 생성
    init() {
        self.viewModel = .init()
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            topContents
            Spacer()
            nextButton
            Spacer().frame(height: 40)
        }
        .customCenterNavigationBar {
            Text("회원가입")
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - TopContents(이메일 로그인 뷰 상단 타이틀 및 텍스트 필드)
    
    /// 이메일 회원가입 상단 콘텐츠
    private var topContents: some View {
        VStack(alignment: .leading, spacing: 32) {
            signupEmailTitle
            signupEmailTextField
        }
    }
    
    /// 이메일 회원가입 뷰 타이틀
    private var signupEmailTitle: some View {
        (
            Text("로그인에 사용할\n")
            + Text("이메일").foregroundStyle(Color.green060)
            + Text("을 입력해주세요")
        )
        .font(.dsTitle2)
        .multilineTextAlignment(.leading)
    }
    
    /// 이메일 회원가입 뷰 텍스트 필드
    private var signupEmailTextField: some View {
        FormTextField(
            fieldType: SignUpFieldType.id,
            focusedField: $focus,
            currentField: .id,
            text: $viewModel.id)
    }
    
    // MARK: - BottomContents(화면 이동 버튼)
    
    /// 유효성 검사 통과시 버튼의 색상 바뀌도록 구현 예정
    private var nextButton: some View {
        PrimaryButton(
            color: viewModel.fieldsNotEmpty ? .green060 :.gray020,
            text: "다음",
            font: .dsTitle3,
            textColor: .gray040,
            height: 50,
            cornerRadius: 10,
            action: {
                /// 이메일 유효성검사 통과시 화면 이동 구현 예정
                print("다음화면이동")
            })
    }
}

#Preview {
    SignupEmailView()
}
