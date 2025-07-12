//
//  View+Extensions.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/10/25.
//

import SwiftUI

extension View {
    func customNavigationBar<TitleContent: View, RightContent: View>(
        @ViewBuilder title: @escaping () -> TitleContent,
        @ViewBuilder right: @escaping () -> RightContent
    ) -> some View {
        modifier(CustomNavigationBarModifier(title: title, right: right))
    }
}
