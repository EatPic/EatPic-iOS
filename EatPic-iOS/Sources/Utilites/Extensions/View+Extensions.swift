//
//  View+Extensions.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/10/25.
//

import SwiftUI

extension View {
    /// 화면 상단의 내비게이션 바에 커스텀 타이틀 뷰와 오른쪽 버튼을 설정합니다.
    ///
    /// SwiftUI의 `.toolbar` 시스템을 기반으로, 가운데 영역(`.principal`)과 오른쪽 영역(`.navigation`)에
    /// 원하는 뷰를 삽입할 수 있도록 추상화한 Modifier입니다.
    /// 일반적으로 `NavigationStack` 내에서 사용됩니다.
    ///
    /// - Parameters:
    ///   - title: 가운데 타이틀 영역에 삽입할 뷰. 텍스트, 이미지, 로고 등 어떤 SwiftUI View도 허용됩니다.
    ///   - right: 오른쪽 버튼 영역에 삽입할 뷰. 주로 `Button`, `Image`, `Menu` 등이 사용됩니다.
    /// - Returns: `CustomNavigationBarModifier`가 적용된 뷰
    ///
    /// - Warning: `.toolbar`는 뷰 계층 내에서 한 번만 선언되어야 하므로, 중첩 사용 시 크래시가 발생할 수 있습니다.
    func customNavigationBar<TitleContent: View, RightContent: View>(
        @ViewBuilder title: @escaping () -> TitleContent,
        @ViewBuilder right: @escaping () -> RightContent
    ) -> some View {
        modifier(CustomNavigationBarModifier(title: title, right: right))
    }
    
    /// .toastView(toast: $toast)를 붙이면 자동으로 ToastModifier가 적용됨
    /// 공용 토스트 뷰를 View에 부착
    func toastView(viewModel: ToastViewModel) -> some View {
        self.modifier(ToastModifier(viewModel: viewModel))
    }
}
