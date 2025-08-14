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
    
    /// 카드 데이터
    let card: PicCard
    
    /// 북마크 여부
    @State private var isBookmarked: Bool = false
    
    /// 댓글 수
    @State private var commentCount: Int = 0
    
    /// 선택된 리액션 이모지
    @State private var selectedReaction: ReactionType?
    
    /// 리액션별 개수
    @State private var reactionCounts: [ReactionType: Int] = [:]
    
    /// 전체 리액션 수
    @State private var totalReactionCount: Int
    
    /// 리액션 바 표시 여부
    @State private var isShowingReactionBar: Bool = false
    
    /// 댓글창 표시 여부
    @State private var isShowingCommentSheet: Bool = false
    
    /// 외부에서 전달받은 토스트 뷰모델
    let toastVM: ToastViewModel
    
    /// 외부에서 전달된 콜백 액션
    var onAction: ((PicCardItemActionType) -> Void)?
    
    // 초기화 메서드 - 카드 데이터를 받아서 초기값 설정
    init(card: PicCard, toastVM: ToastViewModel,
         onAction: ((PicCardItemActionType) -> Void)? = nil) {
        self.card = card
        self.toastVM = toastVM
        self.onAction = onAction
        
        // 카드 데이터로부터 초기값 설정
        self._isBookmarked = State(initialValue: card.bookmarked)
        self._commentCount = State(initialValue: card.commentCount)
        self._totalReactionCount = State(initialValue: card.reactionCount)
        
        // 사용자의 현재 반응 설정
        if let userReaction = card.userReaction {
            self._selectedReaction = State(initialValue: ReactionType(rawValue: userReaction))
        } else {
            self._selectedReaction = State(initialValue: nil)
        }
    }
    
    /// 렌더링 될 각 버튼 항목 구성
    private var items: [PicCardItemType] {
        [
            .bookmark(isBookmarked),
            .comment(commentCount),
            .reaction(selected: selectedReaction, totalCount: totalReactionCount)
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
                reactionCounts: $reactionCounts,
                onReactionSelected: { reaction in
                    handleReactionSelection(reaction)
                }
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
            toggleBookmark()
        case .comment:
            print("댓글 버튼 탭 - 댓글 수: \(commentCount)")
            print("onAction 콜백 호출 시도")
            onAction?(.comment(count: commentCount))
            print("onAction 콜백 호출 완료")
        case .reaction:
            withAnimation {
                isShowingReactionBar = true
            }
            onAction?(.reaction(selected: selectedReaction, counts: reactionCounts))
        }
    }
    
    /// 북마크 토글 처리
    private func toggleBookmark() {
        isBookmarked.toggle()
        onAction?(.bookmark(isOn: isBookmarked))
        
        if isBookmarked {
            toastVM.showToast(title: "Pic 카드가 저장되었습니다.")
        }
    }
    
    /// 리액션 선택 처리
    private func handleReactionSelection(_ reaction: ReactionType?) {
        let previousReaction = selectedReaction
        selectedReaction = reaction
        
        // 리액션 카운트 업데이트
        updateReactionCounts(previous: previousReaction, new: reaction)
        
        // 외부 액션 호출
        onAction?(.reaction(selected: selectedReaction, counts: reactionCounts))
    }
    
    /// 리액션 카운트 업데이트
    private func updateReactionCounts(previous: ReactionType?, new: ReactionType?) {
        // 이전 리액션 제거
        if let prevReaction = previous {
            reactionCounts[prevReaction] = max(0, (reactionCounts[prevReaction] ?? 0) - 1)
            totalReactionCount = max(0, totalReactionCount - 1)
        }
        
        // 새 리액션 추가
        if let newReaction = new {
            reactionCounts[newReaction] = (reactionCounts[newReaction] ?? 0) + 1
            totalReactionCount += 1
        }
    }
}

#Preview {
    CommunityMainView(container: .init())
}
