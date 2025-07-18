//
//  ReactionBarView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/15/25.
//

import SwiftUI

/// 리액션 타입
enum ReactionType: Int, CaseIterable, Identifiable {
    case thumbsUp, heart, yummy, strong, laugh

    var id: Int { rawValue }

    var emoji: String {
        switch self {
        case .thumbsUp: return "👍🏻"
        case .heart:    return "❤️"
        case .yummy:    return "😋"
        case .strong:   return "💪🏻"
        case .laugh:    return "🤣"
        }
    }
}

/// - Parameters:
///   - selectedReaction: 현재 선택된 리액션 (하나만 선택 가능, nil이면 선택 없음)
///   - reactionCounts: 각 리액션 타입별 공감 수 (Int). 99를 초과하면 "99+"로 표시됩니다.
struct ReactionBarView: View {
    @Binding var selectedReaction: ReactionType?     // 현재 선택된 리액션
    @Binding var reactionCounts: [ReactionType: Int] // 각 리액션 타입별 공감 수

    var body: some View {
        HStack(spacing: 16) {
            ForEach(ReactionType.allCases) { reaction in
                Button {
                    toggleReaction(reaction)
                } label: {
                    VStack(spacing: 0) {
                        Text(reaction.emoji)
                            .font(.dsHeadline)
                        Text(countText(for: reaction))
                            .font(.dsCaption2)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 11)
                    .padding(.top, 6)
                    .padding(.bottom, 3)
                    .background(
                        Circle()
                            .fill(selectedReaction == reaction ?
                                  Color.pink060 : Color.black.opacity(0.8))
                    )
                }
            }
        }
        .padding(.horizontal, 48)
        .frame(maxWidth: .infinity)
    }

    // 리액션 선택/해제 처리
    private func toggleReaction(_ reaction: ReactionType) {
        if selectedReaction == reaction {
            selectedReaction = nil
            reactionCounts[reaction, default: 1] -= 1
        } else {
            if let previous = selectedReaction {
                reactionCounts[previous, default: 1] -= 1
            }
            selectedReaction = reaction
            reactionCounts[reaction, default: 0] += 1
        }
    }

    // 공감 수 텍스트 (99 이상은 "99+")
    private func countText(for reaction: ReactionType) -> String {
        let count = reactionCounts[reaction, default: 0]
        return count > 99 ? "99+" : "\(count)"
    }
}

#Preview {
    @Previewable @State var selected: ReactionType? = nil
    @Previewable @State var counts: [ReactionType: Int] = [
        .thumbsUp: 102,
        .heart: 98,
        .yummy: 32,
        .strong: 12,
        .laugh: 44
    ]
    
    return ReactionBarView(
        selectedReaction: $selected,
        reactionCounts: $counts
    )
}
