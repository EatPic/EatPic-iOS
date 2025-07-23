//
//  RecomPicCard.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//
import SwiftUI

struct RecomPicCard: View {
    var body: some View {
            
            VStack {
                HStack {
                    Text("추천 Pic카드")
                        .font(.title3)
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
                
                // 카드 리스트
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray030)
                                .frame(width: 103, height: 103)
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
    RecomPicCard()
}
