//
//  ReactionBarView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/15/25.
//

import SwiftUI

/// 리액션 타입
enum ReactionType: String, CaseIterable, Identifiable {
    case thumbsUp, heart, yummy, strong, laugh
    
    var id: String { rawValue }
    
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
///   - onReactionSelected: 리액션이 선택되었을 때 호출되는 콜백

struct ReactionBarView: View {
    @Binding var selectedReaction: ReactionType?     // 현재 선택된 리액션
    @Binding var reactionCounts: [ReactionType: Int] // 각 리액션 타입별 공감 수
    var onReactionSelected: (ReactionType?) -> Void // 리액션 선택 콜백
    
    init(
            selectedReaction: Binding<ReactionType?>,
            reactionCounts: Binding<[ReactionType: Int]>,
            onReactionSelected: @escaping (ReactionType?) -> Void = { _ in }
        ) {
            self._selectedReaction = selectedReaction
            self._reactionCounts = reactionCounts
            self.onReactionSelected = onReactionSelected
        }
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(ReactionType.allCases) { reaction in
                Button {
                    toggleReaction(reaction)
                } label: {
                    VStack(spacing: 1) {
                        Text(reaction.emoji)
                            .font(.dsHeadline)
                        Text(countText(for: reaction))
                            .font(.dsCaption2)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 6)
                .padding(.bottom, 3)
                .background(alignment: .center) {
                    Circle()
                        .fill(selectedReaction == reaction ?
                              Color.pink060 : Color.black.opacity(0.8))
                        .frame(width: 40, height: 40)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .padding(.horizontal, 48)
        .padding(.bottom, 16)
    }
    
    // 리액션 선택/해제 처리
    private func toggleReaction(_ reaction: ReactionType) {
        print("=== ReactionBarView toggleReaction ===")
        print("선택된 리액션: \(reaction)")
        print("현재 selectedReaction: \(String(describing: selectedReaction))")
        
        let newReaction: ReactionType?
        
        if selectedReaction == reaction {
            // 같은 리액션을 다시 누르면 해제
            selectedReaction = nil
            reactionCounts[reaction, default: 1] -= 1
            newReaction = nil
            print("리액션 해제됨")
        } else {
            // 이전 리액션이 있다면 감소
            if let previous = selectedReaction {
                reactionCounts[previous, default: 1] -= 1
                print("이전 리액션 \(previous) 감소")
            }
            // 새 리액션 선택
            selectedReaction = reaction
            reactionCounts[reaction, default: 0] += 1
            newReaction = reaction
            print("새 리액션 \(reaction) 선택됨")
        }
        
        print("업데이트된 reactionCounts: \(reactionCounts)")
                print("================================")
                
                // 콜백 호출
        onReactionSelected(newReaction)
    }
    
    // 공감 수 텍스트 (99 이상은 "99+")
    private func countText(for reaction: ReactionType) -> String {
        let count = reactionCounts[reaction, default: 0]
        return count > 99 ? "99+" : "\(count)"
    }
}

#Preview {
    CommunityMainView()
}

#Preview {
    @Previewable @State var selected: ReactionType?
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
