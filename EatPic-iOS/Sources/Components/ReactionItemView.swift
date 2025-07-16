//
//  ReactionItemView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/16/25.
//

import SwiftUI

struct ReactionItemView: View {
    
    let commentCount: Int
    let reactionCounts: [ReactionType: Int]
    
    @State private var isBookmarked: Bool = false
    @State private var isShowingReactionBar: Bool = false
    @State private var selectedReaction: ReactionType? = nil
    @State private var internalReactionCounts: [ReactionType: Int] = [:]
    
    // MARK: - Init
    init(
        commentCount: Int,
        reactionCounts: [ReactionType: Int]
    ) {
        self.commentCount = commentCount
        self.reactionCounts = reactionCounts
        self._internalReactionCounts = State(initialValue: reactionCounts)
    }
    
    // MARK: - body
    var body: some View {
        if isShowingReactionBar {
            //            ReactionBarView(
            //                selectedReaction: $selectedReaction,
            //                reactionCounts: $reactionCounts
            //            )
        } else {
            VStack(alignment: .leading, spacing: 16) {
                
                // 북마크 버튼
                Button {
                    isBookmarked.toggle()
                } label: {
                    Image(isBookmarked ? "icon_bookmark_selected" : "icon_bookmark")
                }
                
                // 댓글 버튼
                Button {
                    print("댓글 창 열기")
                    // 여기에 댓글 열기 동작 추가
                } label: {
                    HStack(spacing: 8) {
                        Image("icon_comment")
                        Text("\(commentCount)")
                            .font(.dsHeadline)
                            .foregroundStyle(Color.white)
                            .padding(.top, 4)
                    }
                }
                
                // 공감 버튼
                Button {
                    isShowingReactionBar = true
                } label: {
                    if let selected = selectedReaction {
                        HStack(spacing: 8) {
                            Text(selected.emoji)
                                .font(.dsHeadline)
                            Text(reactionCountText())
                                .font(.dsHeadline)
                                .foregroundStyle(Color.white)
                                .padding(.top, 4)
                        }
                    } else {
                        HStack(spacing: 8) {
                            Image("icon_emotion")
                            Text(reactionCountText())
                                .font(.dsHeadline)
                                .foregroundStyle(Color.white)
                                .padding(.top, 4)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.blue)
        }
    }
    
    private func reactionCountText() -> String {
        let total = reactionCounts.values.reduce(0, +)
        return total > 999 ? "999+" : "\(total)"
    }
}

#Preview {
    @Previewable @State var sampleReactions: [ReactionType: Int] = [
        .thumbsUp: 10,
        .heart: 15,
        .yummy: 5,
        .strong: 3,
        .laugh: 2
    ]
    
    ReactionItemView(
        commentCount: 3,
        reactionCounts: sampleReactions
    )
}
