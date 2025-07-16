//
//  Font+Extensions.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/10/25.
//

import SwiftUI

extension Font {
    enum AppleSDGothicNeo {
        case bold
        case regular
        
        var value: String {
            switch self {
            case .bold:
                return "AppleSDGothicNeo-Bold"
            case .regular:
                return "AppleSDGothicNeo-Regular"
            }
        }
    }
    
    /// AppleSDGothicNeo 폰트를 반환하는 Helper 함수입니다.
    /// - Parameters:
    ///   - type: AppleSDGothicNeo의 폰트 종류
    ///   - size: 폰트 크기 (pt 단위)
    /// - Returns: 지정된 스타일의 SwiftUI Font 객체
    static func appleSDGothicNeo(type: AppleSDGothicNeo, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // MARK: - 디자인 시스템 기반한 타이포그래피 (AppleSDGothicNeo)
    
    /// Ag LargeTitle 34pt
    static var dsLargeTitle: Font {
        appleSDGothicNeo(type: .bold, size: 34)
    }

    /// Ag Title1 28pt
    static var dsTitle1: Font {
        appleSDGothicNeo(type: .bold, size: 28)
    }

    /// Ag Title2 22pt
    static var dsTitle2: Font {
        appleSDGothicNeo(type: .bold, size: 22)
    }

    /// Ag Title3 20pt
    static var dsTitle3: Font {
        appleSDGothicNeo(type: .bold, size: 20)
    }

    /// Ag Headline 17pt
    static var dsHeadline: Font {
        appleSDGothicNeo(type: .bold, size: 17)
    }

    /// Ag Body 17pt
    static var dsBody: Font {
        appleSDGothicNeo(type: .regular, size: 17)
    }

    /// Ag Callout 16pt
    static var dsCallout: Font {
        appleSDGothicNeo(type: .regular, size: 16)
    }

    /// Ag Subhead 15pt
    static var dsSubhead: Font {
        appleSDGothicNeo(type: .regular, size: 15)
    }

    /// Ag Footnote 13pt
    static var dsFootnote: Font {
        appleSDGothicNeo(type: .regular, size: 13)
    }

    /// Ag Caption1 12pt
    static var dsCaption1: Font {
        appleSDGothicNeo(type: .regular, size: 12)
    }

    /// Ag Caption2 11pt
    static var dsCaption2: Font {
        appleSDGothicNeo(type: .regular, size: 11)
    }

    /// Ag Bold 15pt
    static var dsBold15: Font {
        appleSDGothicNeo(type: .bold, size: 15)
    }

    /// Ag Bold 13pt
    static var dsBold13: Font {
        appleSDGothicNeo(type: .bold, size: 13)
    }
    
}
