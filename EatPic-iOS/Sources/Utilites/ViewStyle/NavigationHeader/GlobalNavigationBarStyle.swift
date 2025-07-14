//
//  GlobalNavigationBarStyle.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import UIKit

/// 앱 전역에서 사용할 커스텀 네비게이션 헤더 스타일
enum GlobalNavigationBarStyle {
    /// 앱 전체 공통 스타일
    static func apply() {
        /// 커스텀 뒤로가기 버튼 이미지를 설정
        let backButtonImage = UIImage(resource: .backBtn)
        
        // preparingThumbnail(of:)는 UIImage의 크기를 원하는 사이즈로 축소(thumbnail)해주는 메서드
        // iOS 15부터 사용할 수 있으며, 이미지 리사이징을 간단하고 효율적으로 수행할 수 있는 API
        let resizedImage = backButtonImage.preparingThumbnail(
            of: CGSize(width: 24, height: 24)
        )?.withRenderingMode(.alwaysOriginal)
        
        /// 새로운 UINavigationBarAppearance를 생성하고 투명 배경으로 구성
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        /// 설정한 커스텀 이미지를 뒤로가기 버튼으로 지정
        appearance.setBackIndicatorImage(
            resizedImage,
            transitionMaskImage: resizedImage
        )
        
        /// 'Back'이라는 텍스트가 기본으로 표시되는데, 이를 완전히 숨기기 위해 텍스트 색상을 투명하게 설정.
        /// 텍스트 자체는 존재하지만 시각적으로 보이지 않게 처리
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButtonAppearance

        /// 설정한 Appearance를 모든 UINavigationBar에 적용(전역 설정)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
