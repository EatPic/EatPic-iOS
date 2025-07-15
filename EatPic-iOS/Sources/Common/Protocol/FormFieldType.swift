//
//  FormFieldType.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import Foundation
import SwiftUI

/// 입력 필드에 사용되는 UI 속성 정의하는 프로토콜
/// 로그인, 회원가입에서 반복적으로 사용되는 텍스트 필드 속성 정의
protocol FormFieldType {
    
    /// 입력 필드의 상단 텍스트
    /// example: "아이디", "비밀번호", "이메일", "닉네임"
    var title: String? { get }
    
    /// 입력 필드 상단 텍스트 폰트
    var titleFont: Font {get}
    
    /// 입력 필드 상단 텍스트 컬러
    var titleTextColor: Color { get }
    
    /// 입력필드 placeholder
    var placeholder: String { get }
    
    /// placeholder 텍스트에 사용할 폰트
    var placeholderFont: Font { get }
    
    /// placeholder 텍스트에 사용할 색상
    var placeholderTextColor: Color { get }
    
    /// SecureField 사용 여부
    /// 비밀번호 입력시 값이 숨겨지도록함, ture일 경우 값 숨겨짐
    var isSecure: Bool { get }
    
    /// 필드에 사용할 키보드 타입
    /// example: .default, .emailAddress, .numberPad 등
    var keyboardType: UIKeyboardType { get }
    
    /// 키보드 리턴 버튼 타입
    /// exapmle: .next, .done, .go
    var submitLabel: SubmitLabel { get }
}
