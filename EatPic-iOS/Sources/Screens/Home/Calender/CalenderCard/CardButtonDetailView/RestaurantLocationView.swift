//
//  RestaurantLocationView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

// CalenderCardView에서 식당 위치 버튼을 누르면 보이는 뷰
struct RestaurantLocationView: View {
    var body: some View {
        // 상단바
        RoundedRectangle(cornerRadius: 0)
            .frame(height: 56)
        
        VStack {
        
            Spacer().frame(height: 22)
            
            // 식당 이름 + 자세한 식당 위치와 버튼
            VStack(alignment: .leading) {
                Text("식당 이름")
                    .font(.title3)
                
                HStack {
                    Text("자세한 식당 위치")
                        .font(.dsBody)
                        .foregroundColor(Color.gray060)
                    
                    Spacer()
                    
                    Button(action: {
                        print("식당 위치 복사")
                    }, label: {
                        Text("복사")
                            .foregroundColor(.white)
                            .font(.dsSubhead)
                            .frame(width: 50, height: 23)
                    })
                    .background(Color.green060)
                    .cornerRadius(5)
                }
            }
            
            Spacer().frame(height: 36)
            
            // Map 지도 뷰
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 544)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    RestaurantLocationView()
}
