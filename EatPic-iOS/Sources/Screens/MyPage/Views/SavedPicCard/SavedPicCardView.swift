//
//  SavedPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/15/25.
//

import SwiftUI

struct SavedPicCardView: View {
    @State private var showDateFilterDialog = false
    @State private var viewModel: SavedPicCardViewModel
    @EnvironmentObject private var container: DIContainer
    
    init(container: DIContainer) {
        self._viewModel = State(
            initialValue: SavedPicCardViewModel(container: container)
        )
    }
    
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
        .task {
            await viewModel.fetchSavedCards()
        }
    }
    
    // MARK: 나의 PicCard, 잇친들의 픽카드 선택 버튼
    private var pickerBtn: some View {
        Picker("", selection: $viewModel.selectedTab) {
            Text("나의 Pic 카드")
                .tag(0)
            Text("잇친들의 Pic 카드")
                .tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
        .onChange(of: viewModel.selectedTab) { _, newValue in
            Task {
                await viewModel.onTabChanged()
            }
        }
    }
    
    // MARK: 하단 ScrollView
    private var cardScroll: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 2),
                GridItem(.flexible(), spacing: 2),
                GridItem(.flexible())
            ], spacing: 6) {
                ForEach(viewModel.feedCards) { card in
                    Rectangle()
                        .remoteImage(url: card.imageUrl)
                        .scaledToFill()
                        .frame(width: 118, height: 118)
                        .clipped()
                        .task {
                            await viewModel.loadNextPageIfNeeded(currentCard: card)
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SavedPicCardView(container: DIContainer())
        .environmentObject(DIContainer())
}
