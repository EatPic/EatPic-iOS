//
//  Font+Extensions.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/10/25.
//

import SwiftUI

extension Font {

    // MARK: - English Fonts (San Francisco)
    
    static func enRegular(size: CGFloat) -> Font {
        return .system(size: size, weight: .regular)
    }

    static func enSemibold(size: CGFloat) -> Font {
        return .system(size: size, weight: .semibold)
    }

    static func enBold(size: CGFloat) -> Font {
        return .system(size: size, weight: .bold)
    }

    // MARK: - Korean Fonts (Apple SD 산돌고딕 Neo)

    static func koRegular(size: CGFloat) -> Font {
        return .custom("AppleSDGothicNeo-Regular", size: size)
    }

    static func koSemibold(size: CGFloat) -> Font {
        return .custom("AppleSDGothicNeo-SemiBold", size: size)
    }

    static func koBold(size: CGFloat) -> Font {
        return .custom("AppleSDGothicNeo-Bold", size: size)
    }
}
