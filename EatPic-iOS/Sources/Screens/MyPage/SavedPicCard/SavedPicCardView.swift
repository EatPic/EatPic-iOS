//
//  SavedPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/15/25.
//

import SwiftUI

struct SavedPicCardView: View {
    @State private var showDateFilterDialog = false
    @State private var selected = 0
    
    var body: some View {
        
        VStack {
            
            Spacer().frame(height: 16)
            
            pickerBtn
            
            Spacer().frame(height: 30)
            
            cardScroll
            
        }
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
    
    // MARK: 나의 PicCard, d잇친들의 픽카드 선택 버튼
    private var pickerBtn: some View {
        Picker("", selection: $selected) {
            Text("나의 Pic 카드")
                .tag(0)
            Text("잇친들의 Pic 카드")
                .tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
    }
    
    // MARK: 하단 ScrollView
    private var cardScroll: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 2),
                GridItem(.flexible(), spacing: 2),
                GridItem(.flexible())
            ], spacing: 6) {
                ForEach(0..<30, id: \.self) { _ in
                    // selected 값에 따라 다른 이미지 표시
                    Image(selected == 0 ? "Community/testImage1" : "Community/testImage2")
                        .resizable()
                        .frame(width: 118, height: 118)
                }
            }
        }
    }
}

#Preview {
    SavedPicCardView()
}
