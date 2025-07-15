//
//  SignUpView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import SwiftUI

/// 회원가입 뷰
struct SignUpView: View {
    // MARK: - Property
    
    /// 로그인 기능 및 상태를 관리하는 ViewModel
    @State var viewModel: SignUpViewModel
    
    /// 현재 포커싱된 입력 필드를 관리하는 FocusState
    @FocusState private var focus: SignUpFieldType?
    
    // MARK: - Init
    /// 기본 생성자: 내부에서 ViewModel 인스턴스 생성
    init() {
        self.viewModel = .init()
    }
    
    // MARK: - Body
    
    /// 공통 컴포넌트 텍스트 필드 임시 테스트
    var body: some View {
        VStack {
            // 아이디 입력 필드
            FormTextField(
                fieldType: SignUpFieldType.id,
                focusedField: $focus,
                currentField: .id,
                text: $viewModel.id // viewModel 작성시 구현
            )
            .onSubmit {
                // SignUpView 작성시 구현 예정
                focus = nil
            }
            
            // 비밀번호 입력 필드
            FormTextField(
                fieldType: .password,
                focusedField: $focus,
                currentField: .password,
                text: $viewModel.password // viewModel 작성시 구현
            )
            .onSubmit {
                focus = nil
            }
        }
    }
}

#Preview("iPhone 16 Pro Max - Light") {
    SignUpView()
        .preferredColorScheme(.light)
}
#Preview("iPhone SE (3rd gen) - Light") {
    SignUpView()
        .preferredColorScheme(.light)
}
