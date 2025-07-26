//
//  SocialLoginTyper.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/25/25.
//

import Foundation
import SwiftUI

/// 소셜 로그인 타입을 정의하는 열거형 (카카오, 애플 로그인)
enum SocialLoginType: CaseIterable {
    case kakao
    case apple
    
    /// 타입마다 적용되는 이미지 반환
    var image: Image {
        switch self {
        case .apple: return Image(.apple)
        case .kakao: return Image(.kakao)
        }
    }
}

/// 소셜 로그인 버튼의 모델
struct SocialLoginItem: Identifiable {
    var id: UUID = .init() // 고유 식별자
    var type: SocialLoginType // 카카오, 애플 로그인 타입 식별
    let action: () -> Void // 버튼 액션
}
