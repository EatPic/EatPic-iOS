//
//  CommunityMainView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/22/25.
//

import SwiftUI

struct CommunityMainView: View {
    
    @EnvironmentObject private var container: DIContainer
    @State private var viewModel = CommunityMainViewModel()
    
//    @State private var selectedUser: CommunityUser = sampleUsers[0]
//    @Bindable private var toastVM = ToastViewModel()
//    @State private var isShowingReportBottomSheet = false
//    @State private var isShowingCommentBottomSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                userListView()
                cardListView()
                lastContentView()
            }
        }
        .scrollIndicators(.hidden)
        .toastView(viewModel: viewModel.toastVM)
        .padding(.horizontal, 16)
        .sheet(isPresented: $viewModel.isShowingReportBottomSheet) {
            ReportBottomSheetView(
                isShowing: $viewModel.isShowingReportBottomSheet,
                onReport: viewModel.handleReport
            )
                .presentationDetents([.large, .fraction(0.7)])
                .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $viewModel.isShowingCommentBottomSheet) {
            CommentBottomSheetView(isShowing: $viewModel.isShowingCommentBottomSheet)
                .presentationDetents([.large, .fraction(0.7)])
                .presentationDragIndicator(.hidden)
        }
    }
    
    // 필터링된 카드 리스트
//    private var filteredCards: [PicCard] {
//        if selectedUser.nickname == "전체" {
//            return sampleCards
//        } else {
//            return sampleCards.filter { $0.user == selectedUser }
//        }
//    }
    
    private func userListView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(sampleUsers) { user in
                    VStack(spacing: 16) {
                        ProfileImageView(
                            image: user.profileImage,
                            size: 64,
                            borderColor: user == viewModel.selectedUser ? .pink050 : .gray040,
                            borderWidth: 3
                        )
                        Text(user.id)
                            .font(.dsSubhead)
                            .foregroundStyle(Color.gray080)
                    }
                    .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
                    .onTapGesture {
                        viewModel.selectUser(user)
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
            ForEach(viewModel.filteredCards) { card in
                // FIXME: - 각 user 당 카드 1개만 프로필 이동 및 메뉴 선택 되는 이슈 (원주연, 25.07.31)
                PicCardView(
                    profileImage: card.user.profileImage ?? Image(systemName: "person.fill"),
                    profileID: card.user.id,
                    time: card.time,
                    menuContent: {
                        Button(role: .destructive, action: {
                            viewModel.isShowingReportBottomSheet = true
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
                    toastVM: viewModel.toastVM,
                    onItemAction: viewModel.handleCardAction
//                        { action in
//                        switch action {
//                        case .bookmark(let isOn):
//                            print("북마크 상태: \(isOn)")
//                        case .comment:
//                            isShowingCommentBottomSheet = true  // 여기서 true로 설정
//                        case .reaction(let selected, let counts):
//                            print("선택된 리액션: \(String(describing: selected)), 리액션 수: \(counts)")
//                        }
//                    }
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
}

#Preview {
    CommunityMainView()
}
