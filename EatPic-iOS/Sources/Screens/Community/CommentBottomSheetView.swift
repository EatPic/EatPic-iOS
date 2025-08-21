//
//  CommentBottomSheetView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import SwiftUI

struct CommentBottomSheetView: View {
    @Binding var isShowing: Bool
    @State var viewModel: CommentViewModel
        
    var body: some View {
        VStack {
            ScrollView {
                BottomSheetView(
                    title: "댓글",
                    content: {
                        LazyVStack(spacing: 0) {
                            if viewModel.comments.isEmpty {
                                    VStack {
                                        Spacer().frame(height: 40)
                                        Text("댓글이 아직 없습니다")
                                            .font(.dsCallout)
                                            .foregroundStyle(Color.gray060)
                                            .multilineTextAlignment(.center)
                                        Spacer()
                                    }
                            } else {
                                ForEach(viewModel.comments, id: \.id) { comment in
                                    commentListView(
                                        userName: comment.user.nameId,
                                        profileImage: comment.user.imageName ?? "Community/itcong",
                                        commentText: comment.text,
                                        time: comment.time
                                    )
                                    .contextMenu {
                                        if viewModel.isMyComment(comment) {
                                            Button(role: .destructive) {
                                                viewModel.deleteComment(comment)
                                            } label: {
                                                Label("삭제하기", systemImage: "trash")
                                            }
                                        } else {
                                            Button(role: .destructive) {
                                                viewModel.reportComment(comment)
                                            } label: {
                                                Label("신고하기", systemImage: "exclamationmark.bubble")
                                            }
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                )
                .padding(.top, 24)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            commentPostView()
        }
        .toastView(viewModel: viewModel.toastVM)
        .padding(.horizontal, 16)
        .sheet(isPresented: $viewModel.isShowingReportBottomSheet) {
            ReportBottomSheetView(
                isShowing: $viewModel.isShowingReportBottomSheet,
                onReport: viewModel.handleReport,
                target: .comment // Enum을 사용하여 댓글 신고용으로 지정
            )
            .presentationDetents([.large, .fraction(0.7)])
            .presentationDragIndicator(.hidden)
        }
        .task(id: viewModel.selectedCardId) {
            if viewModel.selectedCardId != nil {
                await viewModel.fetchComments()
            }
        }
//        .onDisappear {
//            viewModel.nextCursor = nil
//            viewModel.hasNextPage = true
//        }
    }
    
    private func commentListView(
        userName: String,
        profileImage: String,
        commentText: String,
        time: String
    ) -> some View {
        HStack(spacing: 13) {
            // 프로필 이미지
            Image(profileImage)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 16) {
                    Text(userName)
                        .font(.dsHeadline)
                        .foregroundStyle(Color.gray080)
                    
                    Text(time)
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray060)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 2)
                
                Text(commentText)
                    .font(.dsCallout)
                    .foregroundStyle(Color.gray080)
                
                Spacer().frame(height: 4)
                
                Button(action: {
                    print("답댓글 작성하기")
                }, label: {
                    Text("답글 달기")
                        .font(.dsFootnote)
                        .foregroundStyle(Color.gray060)
                })
            }
            Spacer()
        }
        .padding(.top, 14)
        .padding(.bottom, 10)
        .frame(height: 85)
    }
    
    private func commentPostView() -> some View {
        HStack(alignment: .center, spacing: 16) {
            // 프로필 이미지
            Image("Community/itcong")
                .resizable()
                .frame(width: 40, height: 40)
            
            HStack {
                // 댓글 텍스트 필드
                TextField("댓글 달기...", text: $viewModel.commentText)
                    .font(.dsBody)
                
                // 전송 버튼
                Button(action: {
                    Task {
                        await viewModel.postComment()
                    }
                }, label: {
                    if !viewModel.commentText.isEmpty {
                        Image("Community/send_green")
                    } else {
                        Image("Community/send_gray")
                    }
                })
                .disabled(viewModel.commentText.isEmpty) // 텍스트가 비어있으면 버튼 비활성화
            }
            .padding(.vertical, 6)
            .padding(.leading, 16)
            .padding(.trailing, 7)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 50)
                    .stroke(viewModel.commentText.isEmpty ?
                            Color.gray040 : Color.green060,
                            lineWidth: 1)
            }
            .frame(height: 48)
        }
        .background(Color.white)
        .padding(.bottom, 16)
        .padding(.top, 6)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CommentBottomSheetView(
        isShowing: .constant(true), viewModel: .init(container: .init()))
}
