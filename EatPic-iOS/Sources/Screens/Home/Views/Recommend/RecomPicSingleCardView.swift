//
//  RecomPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

struct RecomPicCardView: View {
    @State private var viewModel: RecomPicSingleCardViewModel
    private let cardId: Int

    init(container: DIContainer, cardId: Int) {
        self.cardId = cardId
        _viewModel = State(initialValue: RecomPicSingleCardViewModel(container: container))
    }

    var body: some View {
        VStack {
            if let card = viewModel.card {
                PicCardView(
                    card: card,
                    menuContent: {
                        Button(role: .destructive) {
                            print("신고하기")
                        } label: {
                            Label("신고하기", systemImage: "exclamationmark.bubble")
                        }
                    },
                    onProfileTap: nil,
                    toastVM: ToastViewModel(),
                    onItemAction: nil
                )
            } else {
                ProgressView("로딩 중…")
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .task {
            await viewModel.recomPicSingleCard(cardId: cardId)
        }
        .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("확인") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .customNavigationBar {
            Text("Pic 카드")
                .font(.dsTitle2)
                .foregroundStyle(Color.gray080)
        } right: {
            EmptyView()
        }
    }
}

