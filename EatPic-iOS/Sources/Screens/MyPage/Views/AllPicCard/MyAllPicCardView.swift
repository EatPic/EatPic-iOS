//
//  AllPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/15/25.
//

import SwiftUI

struct MyAllPicCardView: View {
    @State private var showDateFilterDialog = false
    @State private var viewModel: MyAllPicCardViewModel
    @EnvironmentObject private var container: DIContainer
    
    init(container: DIContainer) {
        self._viewModel = State(
            initialValue: MyAllPicCardViewModel(container: container)
        )
    }
    
    var body: some View {
        VStack {
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
                            .onTapGesture {
                                print("Tapped cardId:", card.id)
                                container.router.push(.recomPicSingleCard(cardId: card.id))
                            }
                            .task {
                                await viewModel.loadNextPageIfNeeded(currentCard: card)
                            }
                    }
                }
            }
        }
        .padding(.top, 26)
        .padding(.horizontal, 16)
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
        .task {
            await viewModel.fetchMyCards()
        }
    }
}

#Preview {
    MyAllPicCardView(container: DIContainer())
        .environmentObject(DIContainer())
}
