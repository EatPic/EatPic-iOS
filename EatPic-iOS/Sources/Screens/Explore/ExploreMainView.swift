//
//  ExploreMainView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/29/25.
//

import SwiftUI

// 메인 탐색(Explore) 화면 뷰
struct ExploreMainView: View {
    // 검색창에 입력되는 텍스트 상태
    @State var searchText: String = ""
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0), spacing: 9.5),
        GridItem(.flexible(minimum: 0), spacing: 9.5)
        ]
    
    var body: some View {
        VStack(spacing: 20) {
            searchBar()
            exploreFeed()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    /// 검색 바 구성 뷰
    private func searchBar() -> some View {
        SearchBarView(
            text: $searchText,
            placeholder: "",
            showsDeleteButton: false,
            backgroundColor: .white,
            strokeColor: .gray080,
            onSubmit: {
                print("onSubmit")
            },
            onChange: {_ in 
                print("onChange")
            }
        )
    }
    
    /// 피드 전체 영역: ScrollView + LazyVGrid 구성
    private func exploreFeed() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 9, content: {
                ForEach(0..<9) { index in
                    explorePicCard()
                }
            })
        }
        .scrollIndicators(.hidden)
    }
    
    /// 각 피드 카드 뷰: 게시물 이미지 + 댓글/공감 수
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
    ExploreMainView()
}
