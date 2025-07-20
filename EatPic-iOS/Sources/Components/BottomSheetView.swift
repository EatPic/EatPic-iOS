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
/// - Parameters:
///   - title: 바텀시트 제목 텍스트
///   - subtitle: 제목 아래에 표시할 뷰 클로저 (예: 설명, 검색창 등)
///   - content: 하단 콘텐츠 뷰 클로저 (예: 댓글 리스트 뷰, 팔로워 등)
struct BottomSheetView<Subtitle: View,Content: View>: View {
    
    // MARK: - Property
    
    // 바텀시트 제목
    let title: String
    
    // 바텀시트 부제목 (친구 찾기 뷰에서 검색 뷰로 활용가능)
    let subtitle: (() -> Subtitle)?
    
    // 서브타이틀 하단 뷰 (리스트뷰)
    let content: () -> Content
    
    // MARK: - Init
    
    /// subtitile 값이 매개변수로 존재할 때
    init(title: String,
         subtitle: @escaping () -> Subtitle, // 기본적으로 nil값
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
