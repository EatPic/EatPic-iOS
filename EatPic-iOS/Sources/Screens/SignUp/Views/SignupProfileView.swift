//
//  SignupProfileView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/28/25.
//
import SwiftUI

struct SignupProfileView: View {
    // MARK: - Property

    /// 유효성검사 로직 맡고있는 ViewModel
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
            Spacer().frame(height: 32)
            topContents
            Spacer()
            profileButton
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

    // MARK: - TopContents(회원가입 프로필 등록 뷰 상단 타이틀 및 텍스트 필드)

    /// 회원가입 프로필 상단 콘텐츠
    private var topContents: some View {
        VStack(alignment: .leading, spacing: 32) {
            signupStepTitle
            signupProfileTitle
        }
    }

    /// 회원가입 프로필 뷰 Step 타이틀
    private var signupStepTitle: some View {
        (
            Text("STEP 3 ")
                .foregroundStyle(Color.green060)
            + Text("/ 3")
        )
        .font(.dsTitle3)
    }

    /// 회원가입 프로필 뷰 타이틀
    private var signupProfileTitle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("프로필 사진을 설정해주세요")
                .font(.dsTitle2)

            Text("추후에 언제든지 변경할 수 있어요")
                .font(.dsFootnote)
                .foregroundStyle(Color.gray060)
        }
    }
    
    /// 프로필 사진 설정 버튼
    private var profileButton: some View {
        HStack(alignment: .center) {
            Spacer()
            Button(
                action: {
                    print("프로필 사진 등록")
                },
                label: {
                    Image(.profileRegister)
                })
            .frame(width: 163, height: 163)
            Spacer()
        }
    }
    // MARK: - BottomContents(화면 이동 버튼)

    /// 유효성 검사 통과시 버튼의 색상 바뀌도록 구현 예정
    private var nextButton: some View {
        PrimaryButton(
            color: .green060,
            text: "다음",
            font: .dsTitle3,
            textColor: .white,
            height: 50,
            cornerRadius: 10,
            action: {
                print("다음화면이동")
            })
    }
}

#Preview {
    SignupProfileView()
}
