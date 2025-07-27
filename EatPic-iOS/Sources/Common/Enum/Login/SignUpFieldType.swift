//
//  SignUpField.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import Foundation
import SwiftUI

/// 회원가입 화면에서 사용할 입력 필드 타입을 정의한 enum
/// 각 케이스에 따라서 입력필드 상단 텍스트, placeholder, 키보드 타입 지정
enum SignUpFieldType: CaseIterable, FormFieldType, Hashable {
    
    /// 아이디 입력 필드
    case id
    /// 비밀번호 입력 필드
    case password
     
    /// 텍스트 입력필드 상단 텍스트
    var title: String? {
        switch self {
        case .id:
            return nil // 상단 텍스트 타이틀을 표시하지 않음
        case .password:
            return "비밀번호 입력"
        }
    }
    
    // 텍스트 필드 상단 타이틀 폰트
    var titleFont: Font {
        return Font.dsHeadline
    }
    
    // 텍스트 필드 상단 타이틀 컬러
    var titleTextColor: Color {
        return Color.gray060
    }
    
    var placeholder: String {
        switch self {
        case .id:
            return "아이디를 입력하세요"
        case .password:
            return "비밀번호를 입력하세요"
        }
    }
    
    // placeholder 폰트
    var placeholderFont: Font {
        return Font.dsBody
    }
    
    // placeholder 텍스트 컬러
    var placeholderTextColor: Color {
        return Color.gray080
    }
    
    /// 보안 입력 여부 (비밀번호면 true)
    var isSecure: Bool {
        switch self {
        case .password:
            return true
        default:
            return false
        }
    }
    
    /// 해당 필드에 맞는 키보드 타입 지정
    /// 예: .default, .emailAddress, .numberPad 등
    var keyboardType: UIKeyboardType {
        .default
    }

    /// 키보드 asubmit 버튼 스타일 설정
    /// - '.next': 다음 필드로 이동
    /// - `.done`: 입력 완료
    /// - 개발 초기상태에서는 .done으로 임시 고정
    var submitLabel: SubmitLabel {
        .done
    }
}
