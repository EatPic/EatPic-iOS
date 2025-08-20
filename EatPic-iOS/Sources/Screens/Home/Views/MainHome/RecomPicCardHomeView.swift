//
//  RecomPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct RecomPicCardHomeView: View {
    @EnvironmentObject private var container: DIContainer
    
    @State private var viewModel: RecomPicCardViewModel
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    let rows = [GridItem(.fixed(103))]
    
    var body: some View {
        VStack {
            HStack {
                Text("추천 Pic카드")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.gray080)
                
                Spacer()
                
                Button(action: {
                    container.router.push(.exploreMain)
                }, label: {
                    Text("전체보기 >")
                        .foregroundStyle(Color.green060)
                        .font(.dsSubhead)
                })
            }
            
            Spacer().frame(height: 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(103))], spacing: 8) {
                    ForEach(viewModel.cards, id: \.cardId) { card in
                        CardThumb(urlString: card.cardImageUrl, cardId: card.cardId)
                            .onTapGesture {
                                print("Tapped cardId:", card.cardId)
                                container.router.push(.recomPicSingleCard(cardId: card.cardId))
                            }
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 19)
        .frame(height: 183)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .task {
            await viewModel.fetchRecommended()
        }
    }
}

#Preview {
    RecomPicCardHomeView(container: DIContainer.init())
}

/// 카드 썸네일 셀
private struct CardThumb: View {
    let urlString: String?
    let cardId: Int

    var body: some View {
        Rectangle()
            .remoteImage(url: urlString)
            .frame(width: 103, height: 103)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}
