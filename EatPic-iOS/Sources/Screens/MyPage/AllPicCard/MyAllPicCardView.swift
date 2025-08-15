//
//  AllPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/15/25.
//

import SwiftUI

struct MyAllPicCardView: View {
    @State private var showDateFilterDialog = false
    
    var body: some View {
        
        VStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 8) {
                    ForEach(0..<30, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.gray020)
                            .frame(width: 118, height: 118)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .customNavigationBar {
            Text("전체 Pic 카드")
        } right: {
            Button(action: {
                showDateFilterDialog = true
            }, label: {
                Image("btn_mypage_filter")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            })
        }
        .confirmationDialog(
            "날짜 설정하기",
            isPresented: $showDateFilterDialog,
            titleVisibility: .visible
        ) {
            Button("최근 7일") {
                print("최근 7일 버튼 클릭")
            }
            
            Button("최근 30일") {
                print("최근 30일 버튼 클릭")
            }
            
            Button("사용자 지정") {
                print("사용자 지정 버튼 클릭")
            }
            
            Button("취소", role: .cancel) {
            }
        }
    }
}

#Preview {
    MyAllPicCardView()
}
