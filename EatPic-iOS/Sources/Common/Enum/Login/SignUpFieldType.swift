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
    
    /// 로그인뷰에서 사용되는 입력 아이디 필드
    case loginId
    
    /// 로그인뷰에서 사용되는 입력 패스워드 필드
    case loginPassword
    
    /// 이메일 입력 필드
    case email
    
    /// 비밀번호 입력 필드
    case password
    
    /// 닉네임 입력 필드
    case nickname
    
    /// 비밀번호 확인 입력 필드
    case confirmPassword
    
    /// 아이디 입력 필드
    case id
    
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
        case .loginId:
            return "abc@email.com"
        case .loginPassword:
            return "6자리 이상의 비밀번호"
        case .email:
            return "abc@email.com"
        case .password:
            return "6자리 이상의 비밀번호"
        case .nickname:
            return "2자 이상의 한글 입력"
        case .confirmPassword:
            return "다시 한 번 입력해주세요"
        case .id:
            return "5~8자 사이의 소문자 및 숫자 입력"
        }
    }
    
    // placeholder 폰트
    var placeholderFont: Font {
        return Font.dsBody
    }
    
    // placeholder 텍스트 컬러
    var placeholderTextColor: Color {
        return Color.gray050
    }
    
    /// 보안 입력 여부 (비밀번호면 true)
    var isSecure: Bool {
        switch self {
        case .password:
            return true
        case .confirmPassword:
            return true
        default:
            return false
        }
    }
    
    /// 해당 필드에 맞는 키보드 타입 지정
    /// 예: .default, .emailAddress, .numberPad 등
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }
    
    /// 키보드 asubmit 버튼 스타일 설정
    /// - '.next': 다음 필드로 이동
    /// - `.done`: 입력 완료
    /// - 개발 초기상태에서는 .done으로 임시 고정
    var submitLabel: SubmitLabel {
        .done
    }
    
    var showsValidationIcon: Bool {
        switch self {
        case .loginId, .loginPassword:
            return false   // X 버튼만 나오도록 
        default:
            return true    // X + 체크마크 로직
        }
    }
}
