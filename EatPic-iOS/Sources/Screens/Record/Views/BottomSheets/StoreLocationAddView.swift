//
//  StoreLocationAddView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

struct StoreLocationAddView: View {
    // 검색창에 입력되는 텍스트 상태
    @State var searchText: String = ""
    
    var body: some View {
        TopBanner()
        
        Spacer().frame(height: 78)

        HStack {
            // 검색바
            searchBar()
            
            Spacer().frame(width: 9)
            
            PrimaryButton(
                color: .green060,
                text: "추가",
                font: .dsHeadline,
                textColor: .white,
                width: 64,
                height: 40,
                cornerRadius: 10
            ) {
                // TODO: 식당위치 추가 액션
            }
        }
        .padding(.horizontal, 19)
    }
    
    /// 검색 바 구성 뷰
    private func searchBar() -> some View {
        SearchBarView( // 검색창
            text: $searchText,
            placeholder: "닉네임 또는 아이디로 검색",
            showsDeleteButton: false,
            backgroundColor: .gray020,
            strokeColor: nil,
            onSubmit: {
                // TODO: 식당위치 검색 값 보내기? 액션
            },
            onChange: { _ in
                // TODO: 식당위치 결과 값 가져오기? 액션
            })
    }
}

private struct TopBanner: View {
    var body: some View {
        VStack {
            ZStack {
                Text("식당 위치 추가")
                    .font(.dsTitle2)

                HStack {
                    Spacer()
                    Button(action: {
                        // TODO: RecomPicCardView로 Navigation
                    }, label: {
                        Image("Record/btn_home_close")
                    })
                }
            }
            .padding(.horizontal, 19)
        }
    }
}

#Preview {
    StoreLocationAddView()
}
