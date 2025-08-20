//
//  ExploreMainView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/29/25.
//

import SwiftUI
import Combine

enum ExploreMode: Equatable {
    case exploreFeed
    case searchResults
    case hashtagFeed(hashtagId: Int, title: String)
}

// 메인 탐색(Explore) 화면 뷰
struct ExploreMainView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel: ExploreViewModel
    
    @State private var mode: ExploreMode = .exploreFeed
    @State private var searchText: String = ""
    
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0), spacing: 9.5),
        GridItem(.flexible(minimum: 0), spacing: 9.5)
    ]
    
    init(container: DIContainer) {
        self._viewModel = StateObject(
            wrappedValue: .init(container: container))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            searchBar()
            if case .searchResults = mode,
               !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                SearchResultListView(viewModel: viewModel, mode: $mode)
            } else {
                exploreFeed()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .task {
            if case .exploreFeed = mode {
                await viewModel.fetch(limit: 20)
            }
        }
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
                Task {
                    await viewModel.updateQuery(searchText)
                }
                // 두 글자 이상
                if searchText.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 {
                    mode = .searchResults
                }
            },
            onChange: { newText in
                Task {
                    await viewModel.updateQuery(newText)
                }
                let trimmed = newText.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.count >= 2 {
                    mode = .searchResults
                } else {
                    mode = .exploreFeed
                }
            }
        )
    }
    
    /// 피드 전체 영역: ScrollView + LazyVGrid 구성
    private func exploreFeed() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 9, content: {
                ForEach(viewModel.cards) { card in
                    Button {
                        container.router.push(.exploreSelected(cardId: card.id))
                    } label: {
                        ExplorePicCardView(
                            imageURL: card.imageURL,
                            commentCount: card.commentCount,
                            reactionCount: card.reactionCount
                        )
                    }
                }
            })
        }
        .scrollIndicators(.hidden)
    }
}

/// 검색 결과 리스트 (계정 / 해시태그 섹션)
private struct SearchResultListView: View {
    @ObservedObject private var viewModel: ExploreViewModel
    
    @Binding private var mode: ExploreMode
    
    init(
        viewModel: ExploreViewModel,
        mode: Binding<ExploreMode>
    ) {
        self.viewModel = viewModel
        self._mode = mode
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Accounts Section
                if !viewModel.accounts.isEmpty
                    || viewModel.isLoadingAccounts {
                    Text("계정")
                        .font(.headline)
                        .padding(.horizontal, 4)
                    VStack(spacing: 8) {
                        ForEach(
                            viewModel.accounts as [AccountSummary],
                            id: \AccountSummary.userId
                        ) { (acc: AccountSummary) in
                            Button {
                                // 계정 탭 임시 정책: 아직 API 미제작이므로 토스트/무시
                                // 추후 라우팅 교체
                            } label: {
                                HStack(spacing: 12) {
                                    if acc.profileImageURL != nil {
                                        Circle()
                                            .remoteImage(url: acc.profileImageURL)
                                            .frame(width: 47, height: 47)
                                            .clipShape(Circle())
                                    } else {
                                        Image(.Community.itcong)
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .clipShape(Circle())
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(acc.nickname)
                                            .font(.dsBold15)
                                        Text(acc.nameId)
                                            .font(.dsBold15)
                                            .foregroundStyle(Color.gray)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        // Accounts pagination trigger
                        if viewModel.hasNextAccounts {
                            HStack {
                                Spacer()
                                ProgressView().onAppear {
                                    Task { await viewModel.loadMoreAccounts() }
                                }
                                Spacer()
                            }
                        }
                    }
                }

                // Hashtags Section
                if !viewModel.hashtags.isEmpty || viewModel.isLoadingHashtags {
                    Text("해시태그")
                        .font(.headline)
                        .padding(.horizontal, 4)
                    VStack(spacing: 8) {
                        ForEach(viewModel.hashtags, id: \.hashtagId) { tag in
                            Button {
                                Task {
                                    await viewModel.fetchHashtagFeed(
                                        hashtagId: tag.hashtagId, limit: 20)
                                    // 검색어는 유지하되 결과 화면 전환
                                    withAnimation {
                                        mode = .hashtagFeed(
                                            hashtagId: tag.hashtagId, title: tag.title)
                                    }
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Image(.Explore.searchHashtagImg)
                                        .resizable()
                                        .renderingMode(.original)
                                        .frame(width: 47, height: 47)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("#\(tag.title)")
                                            .font(.dsSubhead)
                                            .foregroundStyle(.black)
                                        
                                        Text("게시물 \(tag.postCount)개")
                                            .font(.dsSubhead)
                                            .foregroundStyle(Color.gray060)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        // Hashtags pagination trigger
                        if viewModel.hasNextHashtags {
                            HStack {
                                Spacer()
                                ProgressView().onAppear {
                                    Task { await viewModel.loadMoreHashtags() }
                                }
                                Spacer()
                            }
                        }
                    }
                }

                if viewModel.isEmptyResults
                    && !(viewModel.isLoadingAccounts
                         || viewModel.isLoadingHashtags) {
                    Text("검색 결과가 없습니다.")
                        .font(.dsBold15)
                        .foregroundStyle(Color.gray050)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 24)
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ExploreMainView(container: .init())
}
