//
//  PicCardItemType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/19/25.
//

import Foundation
import SwiftUI

// MARK: - PicCardItemType
// ReactionItemView 내부 버튼 렌더링을 위한 Enum 기반 모델

/// ReactionItemView 내에 표시되는 세 가지 항목: 북마크, 댓글, 리액션
/// 각 항목은 아이콘과 count를 통해 공통 렌더링 인터페이스 제공
enum PicCardItemType {
    case bookmark(Bool)         // 북마크 여부
    case comment(Int)           // 댓글 개수
    case reaction(Int, ReactionType?)   // 총 리액션 수, 선택된 리액션
    
    var id: String {
        switch self {
        case .bookmark: return "bookmark"
        case .comment: return "comment"
        case .reaction: return "reaction"
        }
    }
    
    /// 아이콘 렌더링
    @ViewBuilder
    var icon: some View {
        switch self {
        case .bookmark(let isBookmarked):
            Image(isBookmarked ? "icon_bookmark_selected" : "icon_bookmark")
        case .comment:
            Image("icon_comment")
        case .reaction(_, let selected):
            if let emoji = selected?.emoji {
                Text(emoji)
                    .font(.dsHeadline)
                    .background(alignment: .center) {
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                    }
                    .padding(8)
            } else {
                Image("icon_emotion")
            }
        }
    }
    
    /// 숫자 카운트 표시 (북마크 제외)
    var count: Int? {
        switch self {
        case .bookmark:
            return nil
        case .comment(let value):
            return value
        case .reaction(let value, _):
            return value
        }
    }
}

// MARK: - ReactionItemActionType
// ReactionItemView와 외부 로직을 연결하기 위한 사용자 액션 타입 enum

/// 사용자 인터랙션을 외부에 알리기 위한 액션 타입 정의
/// - bookmark: 북마크 토글 이벤트
/// - comment: 댓글 버튼 클릭 이벤트
/// - reaction: 리액션 선택 또는 변경 이벤트
enum PicCardItemActionType {
    case bookmark(isOn: Bool)
    case comment(count: Int)
    case reaction(selected: ReactionType?, counts: [ReactionType: Int])
}
