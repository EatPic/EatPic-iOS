//
//  RecomPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct RecomPicCardView: View {
    var body: some View {
        VStack {
            
            Menu {
                Button(action: {
                    print("사진 앱에 저장")
                }) {
                    Label("사진 앱에 저장", systemImage: "square.and.arrow.down")
                }
                
                Button(action: {
                    print("수정하기")
                }) {
                    Label("수정하기", systemImage: "square.and.pencil")
                }
                
                // role을 destructive로 설정 시, 빨간 버튼으로 만들 수 있음
                Button(role: .destructive, action: {
                    print("삭제하기")
                }) {
                    Label("삭제하기", systemImage: "exclamationmark.bubble")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .frame(width: 24, height: 6)
                    .padding(.trailing, 2)
                    .foregroundStyle(Color.black)
            }
            
        }
    }
}

#Preview {
    RecomPicCardView()
}
