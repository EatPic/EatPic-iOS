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
    /// 유효성검사 목적 ViewModel, 초기에는 SignUpViewModel 선언
    @Bindable var viewModel: SignUpViewModel = .init()
    
    /// 현재 포커싱된 입력 필드를 관리하는 FocusState
    @FocusState private var focus: SignUpFieldType?
     
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            Spacer()
            topContents
            
            middleContents
            Spacer()
        }
        .padding(.horizontal, 16)
        .customCenterNavigationBar {
            Text("이메일로 로그인")
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
                fieldType: SignUpFieldType.id,
                focusedField: $focus,
                currentField: .id,
                text: $viewModel.id)
            
            /// 비밀번호 텍스트필드 및 타이틀
            FormTextField(
                fieldTitle: "비밀번호",
                fieldType: SignUpFieldType.password,
                focusedField: $focus,
                currentField: .password,
                text: $viewModel.password)
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
        PrimaryButton(
            color: viewModel.fieldsNotEmpty ? .green060 :.gray020,
            text: "로그인",
            font: .dsTitle3,
            textColor: .gray040,
            height: 50,
            cornerRadius: 10,
            action: {
            print("로그인하기")
        })
    }
    
    private var signupButton: some View {
        HStack(alignment: .center, spacing: 8) {
            Spacer()
            
            Text("아직 계정이 없으신가요?")
                .font(.dsSubhead)
                .foregroundStyle(Color.gray060)
            
            Button {
                print("회원가입 이동")
            } label: {
                Text("회원가입 하기")
                    .font(.dsSubhead)
                    .foregroundStyle(Color.green060)
            }
            
            Spacer()
        }
    }
}

struct EmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmailLoginView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE 3rd")

            EmailLoginView()
                .previewDevice("iPhone 16 Pro Max")
                .previewDisplayName("iPhone 16 Pro Max")
        }
    }
}
