//
//  View+Extensions.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/10/25.
//

import SwiftUI
import UIKit

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
    
    /// 화면 상단의 내비게이션 바에 커스텀 타이틀 뷰를 설정합니다.
    ///
    /// SwiftUI의 `.toolbar` 시스템을 기반으로, 가운데 영역(`.principal`)에 원하는 뷰를 삽입할 수 있도록 추상화한 Modifier입니다.
    /// 일반적으로 `NavigationStack` 내에서 사용됩니다.
    ///
    /// - Parameters:
    ///   - title: 가운데 타이틀 영역에 삽입할 뷰. 텍스트, 이미지, 로고 등 어떤 SwiftUI View도 허용됩니다.
    /// - Returns: `CenterNavigationBarModifier`가 적용된 뷰
    ///
    /// - Warning: `.toolbar`는 뷰 계층 내에서 한 번만 선언되어야 하므로, 중첩 사용 시 크래시가 발생할 수 있습니다.
    func customCenterNavigationBar<TitleContent: View>(
        @ViewBuilder title: @escaping () -> TitleContent
    ) -> some View {
        modifier(CenterNavigationBarModifier(title: title))
    }
    
    /// 화면 상단의 내비게이션 바에 커스텀 오른쪽 버튼을 설정합니다.
    ///
    /// SwiftUI의 `.toolbar` 시스템을 기반으로, 오른쪽 영역(`.navigation`)에 원하는 뷰를 삽입할 수 있도록 추상화한 Modifier입니다.
    /// 일반적으로 `NavigationStack` 내에서 사용됩니다.
    ///
    /// - Parameters:
    ///   - right: 오른쪽 버튼 영역에 삽입할 뷰. 주로 `Button`, `Image`, `Menu` 등이 사용됩니다.
    /// - Returns: `RightNavigationBarModifier`가 적용된 뷰
    ///
    /// - Warning: `.toolbar`는 뷰 계층 내에서 한 번만 선언되어야 하므로, 중첩 사용 시 크래시가 발생할 수 있습니다.
    func customRightNavigationBar<RightContent: View>(
        @ViewBuilder right: @escaping () -> RightContent
    ) -> some View {
        modifier(RightNavigationBarModifier(right: right))
    }
    
    /// .toastView(toast: $toast)를 붙이면 자동으로 ToastModifier가 적용됨
    /// 공용 토스트 뷰를 View에 부착
    func toastView(viewModel: ToastViewModel) -> some View {
        self.modifier(ToastModifier(viewModel: viewModel))
    }
    
    /// 현재 View 자리를 네트워크 이미지로 그려주는 Modifier
    ///
    /// 내부 로직으로 Kingfisher 사용하여 이미지 다운로드 및 캐싱함.
    func remoteImage(
        url: String?,
        contentMode: ContentMode = .fill
    ) -> some View {
        modifier(
            NetworkImageModifier(
                url: url,
                contentMode: contentMode
            )
        )
    }
    
    /// 현재 포커스된 First Responder를 해제하여 키보드를 내립니다.
    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil)
    }
    
    /// 서버에서 불러오는 원격 이미지를 **다운샘플링(Downsampling)** 하여 표시하는 뷰 Modifier 헬퍼 함수입니다.
    /// - Parameters:
    ///   - url: 원격 이미지 URL (필수)
    ///   - contentMode: 이미지가 표시될 때의 크기 맞춤 방식 (`.fill`, `.fit` 등). 기본값은 `.fill`
    ///   - targetSize: 다운샘플링 시 목표 크기. 지정하지 않으면 뷰의 실제 크기를 측정하여 사용
    /// - Returns: 다운샘플링이 적용된 `View`
    ///
    /// 이 함수를 사용하면 원본 이미지를 그대로 불러오는 것보다 메모리 사용량이 줄어들고, 스크롤 성능이 개선됩니다.
    /// 내부적으로 `DownsampledRemoteModifier`를 적용합니다.
    func downsampledRemoteImage(
        url: String,
        contentMode: ImageContentMode = .fill,
        targetSize: CGSize? = nil) -> some View {
        modifier(
            DownsampledRemoteModifier(
                url: url,
                contentMode: contentMode,
                targetSize: targetSize
            )
        )
    }
}
