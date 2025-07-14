//
//  SignUpField.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import Foundation
import UIKit

enum SignUpField: CaseIterable, FormFieldType, Hashable {
    
    /// 비밀번호 입력 필드
    case password

    var title: String {
        switch self {
        case .password: return "비밀번호 입력"
        }
    }
    
    var placeholder: String {
        switch self {
        case .password: return "비밀번호를 입력하세요"
        }
    }

    var isSecure: Bool {
        self == .password
    }

    var keyboardType: UIKeyboardType {
        self == .default
    }

    var submitLabel: SubmitLabel {
        .done
    }
}
