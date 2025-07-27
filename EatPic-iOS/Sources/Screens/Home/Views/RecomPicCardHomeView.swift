//
//  RecomPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct RecomPicCardHomeView: View {
    @StateObject private var viewModel = RecomPicCardViewModel()
    
    let rows = [GridItem(.fixed(103))]
    
    var body: some View {
        VStack {
            HStack {
                Text("추천 Pic카드")
                    .font(.dsTitle3)
                    .foregroundColor(.gray080)
                
                Spacer()
                
                Button(action: {
                    print("전체보기")
                }, label: {
                    Text("전체보기 >")
                        .foregroundStyle(Color.green060)
                        .font(.dsSubhead)
                })
            }
            
            Spacer().frame(height: 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(103))], spacing: 8) {
                    ForEach(viewModel.cards) { cards in
                        Image(cards.imageName)
                            .resizable()
                            .frame(width: 103, height: 103)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 19)
        .frame(height: 183)
        .background(.white)
        .cornerRadius(15)
    }
}

#Preview {
    RecomPicCardHomeView()
}
