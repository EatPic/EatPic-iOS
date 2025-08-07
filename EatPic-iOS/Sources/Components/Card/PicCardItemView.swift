//
//  ReactionItemView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/16/25.
//

import SwiftUI

// 카드 하단 인터페이스에서 유저 반응(북마크, 댓글, 리액션)을 표시 및 처리하는 공용 컴포넌트
/// 사용자의 피드백(리액션, 댓글, 북마크)을 보여주고 입력받는 버튼 인터페이스
/// - 외부 이벤트 핸들링(onAction)을 통해 ViewModel이나 부모 뷰와 연동 가능
/// - ReactionBarView와 연계되어 공감 이모지 선택 기능 제공
struct PicCardItemView: View {
    
    /// 북마크 여부
    @State private var isBookmarked: Bool = false
    
    /// 댓글 수
    @State private var commentCount: Int = 0
    
    /// 선택된 리액션 이모지
    @State private var selectedReaction: ReactionType?
    
    /// 리액션별 개수
    @State private var reactionCounts: [ReactionType: Int] = [:]
    
    /// 리액션 바 표시 여부
    @State private var isShowingReactionBar: Bool = false
    
    /// 외부에서 전달된 콜백 액션
    var onAction: ((PicCardItemActionType) -> Void)?
    
    /// 렌더링 될 각 버튼 항목 구성
    private var items: [PicCardItemType] {
        [
            .bookmark(isBookmarked),
            .comment(commentCount),
            .reaction(reactionCounts.values.reduce(0, +), selectedReaction)
        ]
    }
    
    // MARK: - body
    var body: some View {
        // 리액션 바 표시 상태일 경우 배경 터치로 닫기 가능
        if isShowingReactionBar {
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isShowingReactionBar = false
                    }
                }
            
            ReactionBarView(
                selectedReaction: $selectedReaction,
                reactionCounts: $reactionCounts
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        } else {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(items, id: \..id) { item in
                    HStack(spacing: 8) {
                        Button {
                            handleTap(for: item)
                        } label: {
                            item.icon
                        }
                        if let count = item.count {
                            Text(count > 999 ? "999+" : "\(count)")
                                .font(.dsHeadline)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(16)
        }
    }
    
    /// 각 버튼 항목에 대한 탭 처리 및 외부 액션 전달
    private func handleTap(for item: PicCardItemType) {
        switch item {
        case .bookmark:
            isBookmarked.toggle()
            onAction?(.bookmark(isOn: isBookmarked))
        case .comment:
            onAction?(.comment(count: commentCount))
        case .reaction:
            withAnimation {
                isShowingReactionBar = true
            }
            onAction?(.reaction(selected: selectedReaction, counts: reactionCounts))
        }
    }
}

#Preview {
    PicCardItemView { action in
        switch action {
        case .bookmark(let isOn):
            print("북마크 상태: \(isOn)")
        case .comment:
            print("댓글창 열기")
        case .reaction(let selected, _):
            print("선택된 리액션: \(String(describing: selected))")
        }
    }
}

#Preview {
    CommunityMainView()
}
