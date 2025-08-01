//
//  CommunityMainView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/22/25.
//

import SwiftUI

struct CommunityMainView: View {

    @EnvironmentObject private var container: DIContainer
    @State private var selectedUser: CommunityUser = sampleUsers[0]
    @Bindable private var toastVM = ToastViewModel()
    @State private var isShowingReportBottomSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                userListView()
                cardListView()
                lastContentView()
            }
        }
        .scrollIndicators(.hidden)
        .toastView(viewModel: toastVM)
        .padding(.horizontal, 16)
        .sheet(isPresented: $isShowingReportBottomSheet) {
                    reportBottomSheetView()
                }
    }
    
    // 필터링된 카드 리스트
    private var filteredCards: [PicCard] {
        if selectedUser.nickname == "전체" {
            return sampleCards
        } else {
            return sampleCards.filter { $0.user == selectedUser }
        }
    }
    
    private func userListView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(sampleUsers) { user in
                    VStack(spacing: 16) {
                        ProfileImageView(
                            image: user.profileImage,
                            size: 64,
                            borderColor: user == selectedUser ? .pink050 : .gray040,
                            borderWidth: 3
                        )
                        Text(user.id)
                            .font(.dsSubhead)
                            .foregroundStyle(Color.gray080)
                    }
                    .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
                    .onTapGesture {
                        selectedUser = user
                    }
                }
            }
            .frame(maxHeight: 112)
        }
        .scrollIndicators(.hidden)
    }
    
    // 카드 리스트 뷰
    private func cardListView() -> some View {
        LazyVStack(spacing: 32) {
            ForEach(filteredCards) { card in
                // FIXME: - 각 user 당 카드 1개만 프로필 이동 및 메뉴 선택 되는 이슈 (원주연, 25.07.31)
                PicCardView(
                    profileImage: card.user.profileImage ?? Image(systemName: "person.fill"),
                    profileID: card.user.id,
                    time: card.time,
                    menuContent: {
                        Button(role: .destructive, action: {
                            isShowingReportBottomSheet = true
                            print("신고하기")
                        }) {
                            Label("신고하기", systemImage: "exclamationmark.bubble")
                        }
                    },
                    postImage: card.image,
                    myMemo: card.memo,
                    onProfileTap: {
                        container.router.push(.userProfile(user: card.user))
                    },
                    toastVM: toastVM
                )
            }
        }
    }
    
    private func lastContentView() -> some View {
        VStack {
            Spacer().frame(height: 8)
            
            Text("👏🏻")
                .font(.dsLargeTitle)
            
            Spacer().frame(height: 19)
            
            Text("7일 간의 Pic카드를 모두 다 보셨군요!")
                .font(.dsBold15)
            
            Spacer().frame(height: 8)
            
            Text("내일도 잇픽에서 잇친들의 Pic카드를 확인해보세요.")
                .font(.dsFootnote)
            
            Spacer()
        }
        .frame(height: 157)
    }
    
    // 신고 바텀시트 뷰
    private func reportBottomSheetView() -> some View {
        BottomSheetView(
            title: "신고하기",
            subtitle: {
                VStack(spacing: 16) {
                    Text("해당 Pic 카드를 신고하는 이유")
                        .font(.dsTitle2)
                        .foregroundStyle(Color.gray080)
                    Text("회원님의 신고는 익명으로 처리됩니다")
                        .font(.dsFootnote)
                        .foregroundStyle(Color.gray060)
                }
            },
            content: {
                let reportTypes = [
                    "욕설 또는 비방",
                    "음란성/선정적 내용",
                    "도배 또는 광고성 게시물",
                    "거짓 정보 또는 허위 사실",
                    "불쾌감을 주는 이미지 또는 언행",
                    "저작권 침해"
                ]
                
                VStack(spacing: 0) {
                    ForEach(reportTypes, id: \.self) { reportType in
                        reportListView(reportType: reportType)
                            
                    }
                }
            })
    }
    
    private func reportListView(reportType: String) -> some View {
        VStack(spacing: 0) {
            Divider().foregroundStyle(Color.gray030)
            HStack {
                Text(reportType)
                    .font(.dsBody)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray050)
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            .padding(.leading, 28)
            .padding(.trailing, 16)
            .contentShape(Rectangle())
            .onTapGesture {
                handleReport(reportType)
            }
        }
    }
    
    // 신고 버튼 컴포넌트
    private func reportButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Divider().foregroundStyle(Color.gray030)
                HStack {
                    Text(title)
                        .font(.dsBody)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray050)
                }
                .padding(.top, 20)
                .padding(.bottom, 16)
                .padding(.leading, 28)
                .padding(.trailing, 16)
            }
        }
    }
    
    // 신고 처리 함수
    private func handleReport(_ reportType: String) {
        print("신고 유형: \(reportType)")
        isShowingReportBottomSheet = false
        toastVM.showToast(title: "신고되었습니다.")
    }
}

#Preview {
    CommunityMainView()
}
