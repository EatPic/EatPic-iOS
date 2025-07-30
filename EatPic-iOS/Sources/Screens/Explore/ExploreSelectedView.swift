//
//  ExploreSelectedView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/31/25.
//

import SwiftUI

struct ExploreSelectedView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0), spacing: 9.5),
        GridItem(.flexible(minimum: 0), spacing: 9.5)
        ]
    
    var body: some View {
        ScrollView {
            VStack {
                selectedPicCardView()
                recommendedFeedView()
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .customCenterNavigationBar(title: {
            Text("탐색")
                .font(.dsTitle2)
        })
    }
    
    private func selectedPicCardView() -> some View {
        Text("픽카드")
    }
    
    private func recommendedFeedView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("더 찾아보기")
                .font(.dsTitle3)
                .foregroundStyle(.black)
            
            LazyVGrid(columns: columns, spacing: 9, content: {
                ForEach(0..<9) { index in
                    explorePicCard()
                }
            })
        }
    }
    
    private func explorePicCard() -> some View {
        GeometryReader { geometry in
            ZStack {
                Image("Explore/testImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack(spacing: 4) {
                    Image("icon_comment")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("99+")
                        .font(.dsBold13)
                        .foregroundStyle(Color.white)
                    Image("icon_emotion")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("10")
                        .font(.dsBold13)
                        .foregroundStyle(Color.white)
                }
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    ExploreSelectedView()
}
