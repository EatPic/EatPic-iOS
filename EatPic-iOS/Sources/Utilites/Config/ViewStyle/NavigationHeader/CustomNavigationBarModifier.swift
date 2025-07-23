//
//  CustomNavigationBarModifier.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

struct CustomNavigationBarModifier<TitleContent: View, RightContent: View>: ViewModifier {
    let title: () -> TitleContent
    let right: () -> RightContent
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    title()
                }
                
                ToolbarItem(placement: .navigation) {
                    right()
                }
            }
    }
}
