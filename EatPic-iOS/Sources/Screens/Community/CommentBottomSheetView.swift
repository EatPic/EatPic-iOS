//
//  CommentBottomSheetView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import SwiftUI

struct CommentBottomSheetView: View {
    @Binding var isShowing: Bool
    @State private var viewModel = CommentViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                BottomSheetView(
                    title: "댓글",
                    content: {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.comments, id: \.id) { comment in
                                commentListView(
                                    userName: comment.user.id,
                                    profileImage: comment.user.imageName ?? "Community/itcong",
                                    commentText: comment.text,
                                    time: comment.time
                                )
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
    }
    
    private func commentListView(userName: String, profileImage: String,
                                 commentText: String, time: String) -> some View {
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
        .padding(.horizontal, 16)
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
                    .font(.system(size: 14, weight: .regular, design: .default))
                
                // 전송 버튼
                Button(action: {
                    viewModel.postComment()
                }) {
                    if !viewModel.commentText.isEmpty {
                        Image("Community/send_green")
                    } else {
                        Image("Community/send_gray")
                    }
                }
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
        .frame(maxWidth: .infinity)
        .padding(16)
    }
}
