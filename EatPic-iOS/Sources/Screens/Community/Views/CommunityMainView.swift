//
//  CommunityMainView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/22/25.
//

import SwiftUI

struct CommunityMainView: View {
    
    @EnvironmentObject private var container: DIContainer
    @State private var viewModel: CommunityMainViewModel
    
    init(container: DIContainer) {
        self._viewModel = .init(initialValue: .init(container: container))
    }
    
    var body: some View {
        ZStack {
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
                    onReport: viewModel.handleReport,
                    target: .picCard
                )
                .presentationDetents([.large, .fraction(0.7)])
                .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $viewModel.isShowingCommentBottomSheet) {
                CommentBottomSheetView(isShowing: $viewModel.isShowingCommentBottomSheet)
                    .presentationDetents([.large, .fraction(0.7)])
                    .presentationDragIndicator(.hidden)
                    .onAppear {
                        print("CommentBottomSheetView appeared")
                    }
                    .onDisappear {
                        print("CommentBottomSheetView disappeared")
                    }
            }
            
            if viewModel.showDeleteModal {
                DecisionModalView(
                    message: "Pic카드를 정말 삭제하시겠어요?",
                    messageColor: .gray080,
                    leftBtnText: "취소",
                    rightBtnText: "삭제",
                    rightBtnColor: .red050,
                    leftBtnAction: {
                        viewModel.showDeleteModal = false
                    },
                    rightBtnAction: {
                        Task {
                            await viewModel.confirmDeletion()
                        }
                    }
                )
            }
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
    
    private func cardListView() -> some View {
        LazyVStack(spacing: 32) {
            ForEach(viewModel.filteredCards) { card in
                PicCardView(
                    card: card, // card 객체를 통째로 전달
                    menuContent: {
                        if viewModel.isMyCard(card) {
                            Button(action: { viewModel.saveCardToPhotos(card) }, label: {
                                Label("사진 앱에 저장", systemImage: "arrow.down.to.line")
                            })
                            Button(action: { viewModel.editCard(card) },
                                   label: {
                                Label("수정하기", systemImage: "square.and.pencil")
                            })
                            Button(role: .destructive, action: {
                                viewModel.showDeleteConfirmation(for: card)
                            }, label: {
                                Label("삭제하기", systemImage: "trash")
                            })
                        } else {
                            Button(role: .destructive, action: {
                                viewModel.isShowingReportBottomSheet = true
                                print("신고하기")
                            }, label: {
                                Label("신고하기", systemImage: "exclamationmark.bubble")
                            })
                        }
                    },
                    onProfileTap: {
                        container.router.push(.userProfile(user: card.user))
                    },
                    onLocationTap: { latitude, longitude, locationText in
                        // 위치 정보를 확인하고 router로 뷰 이동
                        container.router.push(
                            .storeLocation(
                                latitude: latitude,
                                longitude: longitude,
                                title: locationText
                            )
                        )
                    },
                    toastVM: viewModel.toastVM,
                    onItemAction: { cardId, action in
                        // 카드 ID와 액션을 함께 전달
                        viewModel.handleCardAction(cardId: cardId, action: action)
                    }
                )
            }
        }
        .task {
            await viewModel.fetchFeeds()
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
}
