//
//  SavedPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/15/25.
//

import SwiftUI

struct SavedPicCardView: View {
    @State private var showDateFilterDialog = false
    @State private var selectedSegment = 0
    
    var body: some View {
        
        VStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 2),
                    GridItem(.flexible(), spacing: 2),
                    GridItem(.flexible())
                ], spacing: 6) {
                    ForEach(0..<30, id: \.self) { _ in
                        Image("Community/testImage1")
                            .resizable()
                            .frame(width: 118, height: 118)
                    }
                }
            }
        }
        .padding(.top, 26)
        .padding(.horizontal, 16)
        .customNavigationBar {
            Text("저장한 Pic 카드")
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
    SavedPicCardView()
}
