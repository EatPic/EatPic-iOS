//
//  MediaPickerConfig.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/10/25.
//

import Foundation

/// 이미지 처리 관련 **정책 상수**를 모아둔 설정 구조체입니다.
///
/// - 변경 이유:
///   - 품질/해상도 정책은 앱 전역에서 일관되게 적용되어야 합니다.
///   - 한 곳에서만 값을 수정해 전체 반영되도록 상수화를 수행합니다.
enum MediaPickerConfig {
    /// UI 표시용(피드/상세 뷰 등) 최대 변 길이
    static let displayMaxDimensions: CGFloat = 1200
    
    /// 업로드 전 JPEG 압축 품질 (0.0 ~ 1.0)
    static let jpegCompressionQuality: CGFloat = 0.9
}
