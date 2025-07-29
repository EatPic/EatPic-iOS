//
//  SignupAgreementView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/29/25.
//

import SwiftUI

/// 회원가입 마무리 단계 약관 동의 뷰
struct SignupAgreementView: View {
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
        VStack(alignment: .leading, spacing: 40) {
            Spacer().frame(height: 40)
            topContents
            Spacer()
            nextButton
            Spacer().frame(height: 40)
        }
        .customCenterNavigationBar {
            Text("약관동의")
                .font(.dsTitle2)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - TopContents (약관동의 뷰 상단 타이틀 및 버튼)
    
    /// 약관동의 뷰 상단 콘텐츠
    private var topContents: some View {
        VStack(alignment: .leading, spacing: 32) {
            signupAgreementTitle
            signupAgreementButton
        }
    }
    
    /// 약관동의 뷰 타이틀
    private var signupAgreementTitle: some View {
        (
            Text("EatPic\n")
            + Text("약관 동의").foregroundStyle(Color.green060)
            + Text("가 필요해요")
        )
        .font(.dsTitle2)
        .multilineTextAlignment(.leading)
    }
    
    /// 전체약관 동의 버튼
    private var signupAgreementButton: some View {
        
        Button(
            action: {
                print("전체동의 선택") /// 전체 동의 액션 구현
            },
            label: {
                ZStack {
                    // 버튼배경 테두리
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray040)
                    
                    // 버튼 내부 텍스트 및 이미지
                    HStack(alignment: .center, spacing: 14) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.gray040)
                        Text("서비스 이용약관 전체동의")
                            .foregroundStyle(Color.gray040)
                    }
                }
                .frame(height: 58)
            })
    }
    
    // MARK: - MiddleContents (약관동의 리스트)
    
    // MARK: - BottomContents (화면 이동 다음 버튼)
    
    /// 약관체크 통과시 버튼의 색상 바뀌도록 구현 예정
    private var nextButton: some View {
        PrimaryButton(
            color: viewModel.fieldsNotEmpty ? .green060 :.gray020,
            text: "다음",
            font: .dsTitle3,
            textColor: .gray040,
            height: 50,
            cornerRadius: 10,
            action: {
                /// 약관동의 통과시 화면 이동 구현 예정
                print("다음화면이동")
            })
    }
}

#Preview {
    SignupAgreementView()
}
