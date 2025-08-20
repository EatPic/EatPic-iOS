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
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel = ExploreViewModel()
    
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
        .task {
            await viewModel.fetch(limit: 20)
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
                ForEach(viewModel.cards) { card in
                    Button {
                        container.router.push(.exploreSelected)
                    } label: {
                        explorePicCard(
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
    
    /// 각 피드 카드 뷰: 게시물 이미지 + 댓글/공감 수
    private func explorePicCard(imageURL: URL, commentCount: Int, reactionCount: Int) -> some View {
        GeometryReader { geometry in
            ZStack {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.gray.opacity(0.2)
                    @unknown default:
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(width: geometry.size.width)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))

                
                HStack(spacing: 4) {
                    Image("icon_comment")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("\(commentCount)")
                        .font(.dsBold13)
                        .foregroundStyle(Color.white)
                    Image("icon_emotion")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("\(reactionCount)")
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

// MARK: - Models
struct ExploreCard: Identifiable, Equatable {
    let id: Int
    let imageURL: URL
    let commentCount: Int
    let reactionCount: Int
}

// API Response DTOs
struct ExploreSearchResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ResultPayload

    struct ResultPayload: Decodable {
        let cards: [CardDTO]
        let nextCursor: Int? // null 가능
        let size: Int
        let hasNext: Bool
    }
}

struct CardDTO: Decodable {
    let commentCount: Int
    let reactionCount: Int
    let cardId: Int
    let cardImageURL: URL

    private enum CodingKeys: String, CodingKey {
        case commentCount, reactionCount
        case cardId = "card_id"
        case cardImageURL = "card_image_url"
    }
}

// DTO -> Domain Mapper
extension CardDTO {
    func toDomain() -> ExploreCard {
        ExploreCard(
            id: cardId,
            imageURL: cardImageURL,
            commentCount: commentCount,
            reactionCount: reactionCount
        )
    }
}

import Moya

// MARK: - API Target
enum ExploreAPITarget: APITargetType {
    case search(limit: Int)

    var path: String {
        switch self {
        case .search:
            return "/api/search"
        }
    }

    var method: Moya.Method { .get }

    var task: Task {
        switch self {
        case .search(let limit):
            return .requestParameters(
                parameters: ["limit": limit],
                encoding: URLEncoding.queryString
            )
        }
    }
}

// MARK: - Repository
protocol ExploreRepository {
    func fetchCards(limit: Int) async throws -> [ExploreCard]
}

final class ExploreRepositoryImpl: ExploreRepository {
    private let provider: MoyaProvider<ExploreAPITarget>

    init(provider: MoyaProvider<ExploreAPITarget> = .init()) {
        self.provider = provider
    }

    func fetchCards(limit: Int) async throws -> [ExploreCard] {
        let response = try await provider.asyncRequest(.search(limit: limit))
        let decoded = try JSONDecoder().decode(ExploreSearchResponseDTO.self, from: response.data)
        return decoded.result.cards.map { $0.toDomain() }
    }
}

// MARK: - ViewModel
@MainActor
final class ExploreViewModel: ObservableObject {
    @Published private(set) var cards: [ExploreCard] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil

    private let repository: ExploreRepository

    init(repository: ExploreRepository = ExploreRepositoryImpl()) {
        self.repository = repository
    }

    func fetch(limit: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let items = try await repository.fetchCards(limit: limit)
            self.cards = items
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Moya async helper
private extension MoyaProvider {
    func asyncRequest(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


#Preview {
    ExploreMainView()
}
