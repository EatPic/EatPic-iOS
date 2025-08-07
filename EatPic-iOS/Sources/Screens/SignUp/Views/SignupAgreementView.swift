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
    @State var viewModel: AgreementViewModel
    
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
            
            agreementList
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
                let shouldCheck = !viewModel.agreementList.allSatisfy {
                    $0.isChecked
                }
                viewModel.checkAll(shouldCheck)
            },
            label: {
                ZStack {
                    // 버튼배경 테두리
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            viewModel.agreementList.allSatisfy { $0.isChecked }
                            ? Color.green060
                            : Color.gray050)
                    
                    // 버튼 내부 텍스트 및 이미지
                    HStack(alignment: .center, spacing: 14) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(
                                viewModel.agreementList
                                    .allSatisfy { $0.isChecked }
                                ? Color.green060
                                : Color.gray050)
                        Text("서비스 이용약관 전체동의")
                            .foregroundStyle(
                                viewModel.agreementList.allSatisfy { $0.isChecked }
                                ? Color.green060
                                : Color.gray050)
                    }
                }
                .frame(height: 58)
            })
    }
    
    // MARK: - MiddleContents (약관동의 리스트)
    
    /// 약관동의 체크 리스트
    /// - 버튼의 액션에 따라 상태 토글 적용
    private var agreementList: some View {
        ForEach(
            Array(viewModel.agreementList.enumerated()),
            id: \.element.id
        ) { index, item in
            Button(action: {
                viewModel.toggleAgreement(at: index) // 상태 토글
                
                switch item.type { // 화면 이동
                case .service:
                    container.router.push(.agreementServiceView)
                case .privacy:
                    container.router.push(.agreementPrivacyView)
                case .marketing:
                    container.router.push(.agreementMarketingView)
                }
            }, label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(item.isChecked ? .green060 : .gray050)
                    Text("\(item.title)")
                        .foregroundColor(Color.gray080)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray050)
                }
            })
        }
    }
    
    // MARK: - BottomContents (화면 이동 다음 버튼)
    
    /// 약관체크 통과시 버튼의 색상 바뀌도록 구현 예정
    private var nextButton: some View {
        PrimaryButton(
            // 약관동의 필수사항 체크 됐을시 색 바꾸기
            color: viewModel.isRequiredAllChecked ? .green060 : .gray020,
            text: "다음",
            font: .dsTitle3,
            textColor: viewModel.isRequiredAllChecked ? .white : .gray040,
            height: 50,
            cornerRadius: 10,
            action: {
                /// 약관동의 통과시 화면 이동 구현 예정 (필수사항 체크 유효성 검사하기)
                if viewModel.isRequiredAllChecked {
                    container.router.push(.signupComplementView)
                }
            })
    }
}

#Preview {
    SignupAgreementView()
}
