//
//  ReciptDetailCardView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/14/25.
//

import SwiftUI

struct ReciptDetailCardView: View {
    var body: some View {
        ZStack {
            let screenWidth = UIScreen.main.bounds.width
            Image(systemName: "square.fill")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenWidth)
                .clipped()
                .cornerRadius(20)
                .foregroundStyle(.black.opacity(0.7))
            
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text("#아침")
                        .font(.koBold(size: 15))
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.black)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    
                    Text("#다아섯글자")
                        .font(.koBold(size: 15))
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.black)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    
                    Text("#다아섯글자")
                        .font(.koBold(size: 15))
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.black)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .padding(.leading, 17)
                
                Spacer()
                
                Text("레시피")
                    .font(.koBold(size: 22))
                    .foregroundStyle(Color.white)
                    .padding(.leading, 20)
                
                Spacer().frame(height: 19)
                
                Text("이 레시피는요 일단 야채들이 필요하고요 소스는 편의점에서 스위트 갈릭마요 소스를 뿌렸어요 아보카도랑 당근의 조합이 정말 좋은거 아시나요?")
                    .font(.koRegular(size: 13))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Image("icon_link")
                            .padding(5)
                            .background(
                                Circle().fill(Color.white)
                            )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        HStack(spacing: 4) {
                            Image("icon_navi")
                            Text("가나다라마바사아자차카타파하가나다라")
                                .font(.koBold(size: 15))
                                .foregroundStyle(Color.gray080)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(
                            Color.white
                                .cornerRadius(50)
                        )
                    })
                }
                .padding(.leading, 20)
                .padding(.trailing, 17)
            }
            .padding(.top, 19)
            .padding(.bottom, 23)
            .frame(height: screenWidth)
        }
    }
}

#Preview {
    ReciptDetailCardView()
}
