//
//  PicCardView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/12/25.
//

import SwiftUI

struct PicCardView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            // CardInfoView
            HStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                VStack(alignment: .leading) {
                    Text("아이디")
                        .font(.koBold(size: 17))
                        .foregroundColor(.gray080)
                    Text("오후 6:29")
                        .font(.koRegular(size: 13))
                        .foregroundColor(.gray060)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .frame(width: 24, height: 24)
            }
            
            // CardImageView
            Image(systemName: "square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 360, height: 360)
            
            // CardMemoView
            Text("오늘은 샐러드를 먹었습니다~ 아보카도를 많이 넣어 먹었어요~~ 다들 제 레시피 보고 따라 만들어주시기길ㄹ.....태그도 남겨주시기르를")
                .font(.koRegular(size: 16))
                .foregroundColor(.gray080)
        }
        .frame(maxWidth: 360)
    }
}

#Preview {
    PicCardView()
}
