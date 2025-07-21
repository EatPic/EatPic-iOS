//
//  ToastModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/21/25.
//

import Foundation

/// 토스트 뷰 데이터 모델을 정의하는 구조체
/// - 화면에 띄울 메시지의 제목 ("title")과 표시 지속 시간(duration)을 명시
struct ToastModel {
    /// 사용자에게 표시할 토스트 제목
    let title: String
    
    /// 사용자에게 보여질 토스트 지속 시간(초 단위)
    let duration: TimeInterval
}
