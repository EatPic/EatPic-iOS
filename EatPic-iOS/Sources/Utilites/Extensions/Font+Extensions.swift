//
//  Font+Extensions.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/10/25.
//

import SwiftUI
/**
 Ag LargeTitle 34pt • 34/Auto
 Ag Title1 28pt • 28/Auto
 Ag Title2 22pt • 22/Auto
 Ag Title3 20pt • 20/Auto
 Ag Headline 17pt • 17/Auto
 Ag Body 17pt • 17/Auto
 Ag Callout 16pt • 16/Auto
 Ag Subhead 15pt • 15/Auto
 Ag Footnote 13pt • 13/Auto
 Ag Caption1 12pt • 12/Auto
 Ag Caption2 11pt • 11/Auto
 Ag bold 15pt • 15/Auto
 Ag bold 13pt • 13/Auto
 */
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
    
    static func appleSDGothicNeo(type: AppleSDGothicNeo, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // MARK: - Typography based on design system (AppleSDGothicNeo)
    
    /// Ag LargeTitle 34pt
    static var dsLargeTitle: Font {
        appleSDGothicNeo(type: .bold, size: 34)
    }

    /// Ag Title1 28pt
    static var dsTitle1: Font {
        appleSDGothicNeo(type: .bold, size: 28)
    }

    static var dsTitle2: Font {
        appleSDGothicNeo(type: .bold, size: 22)
    }

    static var dsTitle3: Font {
        appleSDGothicNeo(type: .bold, size: 20)
    }

    static var dsHeadline: Font {
        appleSDGothicNeo(type: .bold, size: 17)
    }

    static var dsBody: Font {
        appleSDGothicNeo(type: .regular, size: 17)
    }

    static var dsCallout: Font {
        appleSDGothicNeo(type: .regular, size: 16)
    }

    static var dsSubhead: Font {
        appleSDGothicNeo(type: .regular, size: 15)
    }

    static var dsFootnote: Font {
        appleSDGothicNeo(type: .regular, size: 13)
    }

    static var dsCaption1: Font {
        appleSDGothicNeo(type: .regular, size: 12)
    }

    static var dsCaption2: Font {
        appleSDGothicNeo(type: .regular, size: 11)
    }

    static var dsBold15: Font {
        appleSDGothicNeo(type: .bold, size: 15)
    }

    static var dsBold13: Font {
        appleSDGothicNeo(type: .bold, size: 13)
    }
    
}
