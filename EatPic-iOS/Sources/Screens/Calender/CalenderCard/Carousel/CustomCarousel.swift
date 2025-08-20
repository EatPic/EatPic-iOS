import SwiftUI

struct CarouselView: View {
    // 부모에서 내려주는 선택 모델
    // @Binding(부모 상태를 자식이 수정): 단일 소스 오브 트루스가 부모에 있고, 자식이 그 값을 읽고/바꾸면 부모 UI도 즉시 반영됨. 지금 케이스에 딱 맞음
    @Binding var selection: ImageModel?
    let data: [ImageModel]
    
    // 내부에서는 ID를 바인딩으로 쓰고, 바뀔 때 selection을 갱신
    // @State(자식 내부 상태): 자식 안에서만 바뀌고 부모는 모름. 그래서 너처럼 상단바/버튼이 부모에서 selection을 보고 바뀌는 구조면 동기화가 안 돼
    @State private var activeID: UUID?
     
    // MARK: 캐러셀 뷰와 공백 UI
    var body: some View {
        VStack {
            CustomCarousel(
                config: .init(hasOpacity: true, hasScale: true),
                selection: Binding<UUID?>(
                    get: { selection?.id ?? activeID },
                    set: { newID in
                        activeID = newID
                        if let id = newID {
                            selection = data.first(where: { $0.id == id })
                        }
                    }
                ),
                data: data
            ) { item in
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .onAppear {
            // 초기 선택값 세팅
            if selection == nil {
                selection = data.first
            }
            activeID = selection?.id
        }
    }
}

// MARK: 캐러셀 뷰
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
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
        }
    }
        
    @ViewBuilder
    func itemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            let progress = minX / (config.cardWidth + config.spacing)
            let minimumCardWidth = config.minimumCardWidth
            
            let diffWidth = config.cardWidth - minimumCardWidth
            let reducingWidth = progress * diffWidth
            let cappedWidth = min(reducingWidth, diffWidth)
            let resizedFrameWidth = config
                .cardWidth - (minX > 0 ? cappedWidth
                              : min(-cappedWidth, diffWidth))
            let scaleValue = config.scaleValue * abs(progress)
            let opacityValue = config.opacityValue * abs(progress)
            
            content(item)
                .frame(width: config.cardWidth, height: config.cardHeight)
                .frame(width: resizedFrameWidth)
                .opacity(config.hasOpacity ? 1 - opacityValue : 1)
                .scaleEffect(config.hasScale ? 1 - scaleValue : 1)
                .mask {
                    let scaledHeight = (1 - scaleValue) * config.cardHeight
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .frame(height: config.hasScale ? scaledHeight : config.cardHeight)
                }
                .offset(x: -reducingWidth)
                .offset(x: min(progress, 1) * diffWidth)
                .offset(x: max(-progress, 0) * diffWidth)
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
