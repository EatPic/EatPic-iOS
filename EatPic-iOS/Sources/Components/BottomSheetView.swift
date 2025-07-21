//
//  BottomSheetView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/19/25.
//

import SwiftUI

/// 공용으로 사용되는 바텀시트 뷰 입니다.
/// 전체적인 구조는 제목 + 부제목 + 부제목 하위 뷰 로 구성되어 있습니다.
/// 댓글창, 신고창, 친구 찾기 바텀시트에서 활용 가능합니다.
/// 해당 컴포넌트는 VStack이 Propety마다 간격 30으로 조정되어 있습니다.
/// - Parameters:
///   - title: 바텀시트 제목 텍스트
///   - subtitle: 제목 아래에 표시할 뷰 클로저 (예: 설명, 검색창 등)
///   - content: 하단 콘텐츠 뷰 클로저 (예: 댓글 리스트 뷰, 팔로워 리스트 뷰 등)
struct BottomSheetView<Subtitle: View, Content: View>: View {
    
    // MARK: - Property
    
    // 바텀시트 제목
    let title: String
    
    // 바텀시트 부제목
    let subtitle: (() -> Subtitle)?
    
    // 서브타이틀 하단 뷰 (리스트뷰)
    let content: () -> Content
    
    // MARK: - Init
    
    /// subtitile 값이 매개변수로 존재할 때
    init(title: String,
         subtitle: @escaping () -> Subtitle,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }
    
    /// subtitle 값을 매개변수로 받아오지 않았을 때
    init(title: String,
         @ViewBuilder content: @escaping () -> Content
    ) where Subtitle == EmptyView {
        self.title = title
        self.subtitle = nil
        self.content = content
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text(title)
                .font(.dsTitle2)
                .foregroundStyle(Color.black)
            
            if let subtitle = subtitle {
                subtitle() // 서브타이틀 값 유효할 경우 뷰 렌더링
            }
            
            content()
        }
    }
}

/// 아래는 프로젝트 피그마를 참고하여 간단 사용 예시를 기입해 뒀습니다.
/// subtitle 뷰 및 content 뷰는 추후에 따로 뷰를 만들어 렌더링 해야합니다.
/// 예시: ReportListView(), CommentView(), FollowListView() content 내부 클로져에서 호출
/// - 1. 사용예시  (신고하기 바텀시트)
#Preview("바텀시트 - 신고하기") {
    BottomSheetView(
        title: "신고하기",
        subtitle: {
            VStack(spacing: 16) {
                Text("해당 Pic카드를 신고하는 이유")
                    .font(.dsTitle2)
                Text("회원님의 신고는 익명으로 처리됩니다.")
                    .font(.dsFootnote)
            }
        },
        content: {
            List { // 추후에 ForEach 구문으로 전환하고 ReportListView()로 렌더링
                Text("리스트를 넣으세요")
                Text("리스트를 넣으세요")
            }
            .listStyle(.inset)
        }
    )
}

#Preview("바텀시트 - 댓글창") {
    BottomSheetView(
        title: "댓글 5",
        content: {
            // CommentView 댓글창 렌더링 예정
            Text(" LazyVStack + ScrollView 댓글창 사용 예정")
        }
    )
}

#Preview("바텀시트 - 친구찾기 팔로우 목록") {
    BottomSheetView(
        title: "👍",
        subtitle: {
            Text("데이지가 작업한 SearchBarView 컴포넌트 렌더링 예정")
        },
        content: { // content: FollowListView 팔로우 목록 렌더링
            Text("LazyVStack + ScrollView 팔로우 리스트 렌더링 예정")
        }
    )
}
