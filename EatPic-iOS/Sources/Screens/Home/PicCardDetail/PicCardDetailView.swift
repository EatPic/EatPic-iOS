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
        VStack{
            
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
                    myMemo: "오늘은 토마토 파스타를 만들어 봤어요 🍝 정말 맛있게 완성됐습니다!s alkdd ;fljd s;lfsadfklsf;dfskdjflksjd fljsd"
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
