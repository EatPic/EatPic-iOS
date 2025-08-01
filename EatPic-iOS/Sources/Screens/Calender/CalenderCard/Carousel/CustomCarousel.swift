//
//  CustomCarousel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/29/25.
//

// FIXME: [25.07.29] 각 Carousel 사진마다 개별 뷰 보여줘야함 – 비엔/이은정
import SwiftUI

struct CarouselView: View {
    @State private var activeID: UUID?
     
    var body: some View {
        VStack {
            CustomCarousel(config: .init(hasOpacity: true, hasScale: true),
                           selection: $activeID, data: images) { item in
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

private struct CustomCarousel<Content: View,
                        Data: RandomAccessCollection>:
                            View where Data.Element: Identifiable {
    var config: Config
    @Binding var selection: Data.Element.ID?
    var data: Data
    @ViewBuilder var content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    ForEach(data) { item in
                        itemView(item)
                    } 
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, (size.width - config.cardWidth) / 2)
            .scrollPosition(id: $selection)
            // 캐러샐로 만들기
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            // Hiding Scroll Indicator
            .scrollIndicators(.hidden)
        }
    }
        
    // Item View
    @ViewBuilder
    func itemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            let progress = minX / (config.cardWidth + config.spacing)
            let minimumCardWidth = config.minimumCardWidth
            
            let diffWidth = config.cardWidth - minimumCardWidth
            let reducingWidth = progress * diffWidth
            
            let cappedWidth = min(reducingWidth, diffWidth)
            
            let resizedFrameWidth = config.cardWidth - (minX > 0 ? cappedWidth
                                                        : min(-cappedWidth, diffWidth))
            
            let negativeProgress = max(-progress, 0)
            
            let scaleValue = config.scaleValue * abs(progress)
            let opacityValue = config.opacityValue * abs(progress)
            
            content(item)
                .frame(width: config.cardWidth, height: config.cardHeight)
                .frame(width: resizedFrameWidth)
                .opacity(config.hasOpacity ? 1 - opacityValue : 1)
                .scaleEffect(config.hasScale ? 1 - scaleValue : 1)
                .mask {
                    let hasScale = config.hasScale
                    let scaledHeight = (1 - scaleValue) * config.cardHeight
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .frame(height: hasScale ? scaledHeight : config.cardHeight)
                }
                .offset(x: -reducingWidth)
                .offset(x: min(progress, 1) * diffWidth)
                .offset(x: negativeProgress * diffWidth)
        }
        .frame(width: config.cardWidth, height: config.cardHeight)
    }
    
    struct Config {
        var hasOpacity: Bool = false
        var opacityValue: CGFloat = 0.4
        var hasScale: Bool = false
        var scaleValue: CGFloat = 0.2
        
        var cardWidth: CGFloat = 300
        var cardHeight: CGFloat = 300
        var spacing: CGFloat = 10
        var cornerRadius: CGFloat = 15
        var minimumCardWidth: CGFloat = 40
    }
}

#Preview {
    CarouselView()
}
