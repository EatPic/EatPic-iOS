//
//  PicCardDetailView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct PicCardDetailView: View {
    var body: some View {
        
        // 상단바
        RoundedRectangle(cornerRadius: 0)
            .frame(height: 56)
        
        VStack {
            
            Spacer().frame(height: 16)
            
            ZStack {
                PicCardView(
                    profileImage: Image(systemName: "person.crop.circle.fill"),
                    profileID: "junny.dev",
                    time: "오전 9:12",
                    onEllipsisTapped: {
                        print("더보기 버튼 클릭됨")
                    },
                    postImage: Image("Home/exampleSalad"),
                    myMemo: "ddddddddddd"
                )
                
                PicCardItemView()
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    PicCardDetailView()
}
