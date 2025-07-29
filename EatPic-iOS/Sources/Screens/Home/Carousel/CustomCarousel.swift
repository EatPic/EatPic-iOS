//
//  CustomCarousel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/29/25.
//

import SwiftUI

struct CustomCarousel<Content: View, Data: RandomAccessCollection>: View where Data.Element:Identifiable {
    var config: Config
    @Binding var selection: Data.Element.ID
    var data: Data
    @ViewBuilder var content: (Data.Element) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    ForEach(data) { item in
                        ItemView(item)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, (size.width - config.cardWidth) / 2)
            .scrollPosition(id: $selection)
            .scrollTargetLayout(.viewAligned(limitBehaviour: .always)
            )
        }
    }
        
    @ViewBuilder
    func ItemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            content(item)
            
        }
        .frame(width: config.cardWidth)
    }
    
    struct Config {
        var hasOpacity: Bool = false
        var opacityValue: CGFloat = 0.5
        var hasScale: Bool = false
        var scaleValue: CGFloat = 0.2
        
        var cardWidth: CGFloat = 150
        var spacing: CGFloat = 10
        var cornerRadius: CGFloat = 15
        var minimumCardWidth: CGFloat = 40
    }
}

#Preview{
    ContentView()
}
}
