//
//  Sett.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/14/25.
//

import SwiftUI

struct SettingPageView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var appFlowViewModel: AppFlowViewModel
    
    @State private var viewModel: MyPageMainViewModel
    @State private var isNotificationEnabled = true
    @State private var showLogoutModal = false
    @State private var showWithdrawalModal = false
    
    init(container: DIContainer) {
        self._viewModel = State(initialValue: MyPageMainViewModel(container: container))
    }
    
    var body: some View {
        ZStack {
            VStack {
                
                topNavigationBar
                
                VStack {
                    
                    Spacer().frame(height: 8)
                    
                    userProfileView
                    
                    Spacer().frame(height: 24)
                    
                    settingsView
                    
                    Spacer().frame(height: 16)
                    
                    friendsView
                    
                    Spacer().frame(height: 16)
                    
                    accountView
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .background(Color.gray020.ignoresSafeArea())
            .navigationBarHidden(true) // 기본 네비게이션 바 숨기기
            .task {
                await viewModel.getMyInfo()
            }
            
            // 로그아웃 모달
            if showLogoutModal {
                DecisionModalView(
                    message: "정말 로그아웃 하시겠어요?",
                    messageColor: .gray080,
                    leftBtnText: "아니오",
                    rightBtnText: "예",
                    rightBtnColor: .green060,
                    leftBtnAction: {
                        showLogoutModal = false
                        print("아니오 버튼 클릭, 모달 닫기 액션")
                    },
                    rightBtnAction: {
                        showLogoutModal = false
                        container.userSessionKeychain.deleteSession(for: .userSession)
                        appFlowViewModel.appState = .login
                        container.router.popToRoot()
                    }
                )
            }
            
            // 회원 탈퇴 모달
            if showWithdrawalModal {
                DecisionModalView(
                    message: "회원 탈퇴 시 계정 정보는 복구가 불가능합니다.\n정말로 탈퇴하시겠어요?",
                    messageColor: .gray080,
                    leftBtnText: "아니오",
                    rightBtnText: "탈퇴하기",
                    rightBtnColor: .red050,
                    leftBtnAction: {
                        showWithdrawalModal = false
                    },
                    rightBtnAction: {
                        showWithdrawalModal = false
                    }
                )
            }
        }
    }
    
    // MARK: 상단 네비게이션 바
    private var topNavigationBar: some View {
        HStack {
            Button(action: {
                container.router.pop()
            }, label: {
                Image("backBtn")
                    .resizable()
                    .frame(width: 24, height: 24)
            })
            
            Spacer()
            
            Text("설정")
                .font(.dsTitle2)
                .foregroundStyle(Color.gray080)
            
            Spacer()
            
            // 오른쪽 공간을 맞추기 위한 투명한 뷰
            Color.clear
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
    }
    
    // MARK: 사용자 프로필 뷰
    private var userProfileView: some View {
        HStack {
            Group {
                if let profileImageUrl = viewModel.user?.profileImageUrl, !profileImageUrl.isEmpty {
                    AsyncImage(url: URL(string: profileImageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image("img_mypage_itcong")
                    }
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                } else {
                    Image("img_mypage_itcong")
                        .resizable()
                        .frame(width: 72, height: 72)
                }
            }
            
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.user?.nickname ?? "잇콩")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.gray080)
                
                Text("@\(viewModel.user?.nameId ?? "itcong")")
                    .font(.dsCallout)
                    .foregroundStyle(Color.gray060)
            }
            
            Spacer()
            
            Button(action: {
                // TODO: [25.08.14] ProfileEditView로 네비게이션 - 비엔/이은정
                container.router.push(.profileEdit)
                print("프로필 편집")
            }, label: {
                Image("btn_mypage_next")
                    .resizable()
                    .frame(width: 24, height: 24)
            })
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: 설정 (알림 설정) 컴포넌트
    private var settingsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("설정")
                .font(.dsCallout)
                .foregroundStyle(Color.gray080)
            
            HStack {
                Image("ic_mypage_noti")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Spacer().frame(width: 8)
                
                Text("알림 설정")
                    .font(.dsBody)
                    .foregroundStyle(Color.gray080)
                
                Spacer()
                
                Toggle("", isOn: $isNotificationEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .pink060))
                    .labelsHidden()
                    .onChange(of: isNotificationEnabled) { _, newValue in
                        if newValue {
                            print("알림 설정 on")
                        } else {
                            print("알림 설정 off")
                        }
                    }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    // MARK: 잇친 (차단된 계정) 뷰
    private var friendsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("잇친")
                .font(.dsCallout)
                .foregroundStyle(Color.gray080)
            
            HStack {
                Image("ic_mypage_ban")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Spacer().frame(width: 8)
                
                Text("차단된 계정")
                    .font(.dsBody)
                    .foregroundStyle(Color.gray080)
                
                Spacer()
                
                Button(action: {
                    container.router.push(.blockedAccount)
                    print("차단된 계정")
                }, label: {
                    Image("btn_mypage_next")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            .padding(.vertical, 17)
            .padding(.horizontal, 16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    // MARK: 계정 (로그아웃 & 회원 탈퇴 버튼) 뷰
    private var accountView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("계정")
                .font(.dsCallout)
                .foregroundStyle(Color.gray080)
            
            VStack(spacing: 0) {
                // 로그아웃 버튼
                Button(action: {
                    showLogoutModal = true
                }, label: {
                    HStack {
                        Text("로그아웃")
                            .font(.dsBody)
                            .foregroundStyle(Color.gray080)
                        
                        Spacer()
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)
                })
                .background(Color.white)
                
                Divider()
                
                // 탈퇴 버튼
                Button(action: {
                    showWithdrawalModal = true
                }, label: {
                    HStack {
                        Text("회원 탈퇴")
                            .font(.dsBody)
                            .foregroundStyle(Color.gray080)
                        
                        Spacer()
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)
                })
                .background(Color.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    SettingPageView(container: .init())
}
