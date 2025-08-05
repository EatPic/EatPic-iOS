//
//  CommentBottomSheetView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import SwiftUI

struct CommentBottomSheetView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ScrollView {
            BottomSheetView(
                title: "댓글",
                content: {
                    LazyVStack(spacing: 0) {
                        ForEach(sampleComments) { comment in
                            commentListView(
                                userName: comment.user.id,
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
    }
    
    private func commentListView(userName: String, commentText: String, time: String) -> some View {
        HStack {
            // 프로필 이미지
            Circle()
                .fill(Color.gray040)
                .frame(width: 40, height: 40)
            
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
                
                Text("답글 달기")
                    .font(.dsFootnote)
                    .foregroundStyle(Color.gray060)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }
}
