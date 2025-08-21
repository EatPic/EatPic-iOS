//
//  ExploreMainViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/21/25.
//

import Foundation
import Moya

// Hashtag cards response uses the same CardDTO as Explore feed
typealias HashtagCardsResponseDTO = ExploreSearchResponseDTO

// MARK: - API Targets
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

enum SearchAPITarget: APITargetType {
    case accounts(query: String, limit: Int?, cursor: Int?)
    case hashtags(query: String, limit: Int?, cursor: Int?)
    case hashtagCards(hashtagIdPath: Int, hashtagIdQuery: Int, limit: Int?)

    var path: String {
        switch self {
        case .accounts:
            return "/api/search/all/account"
        case .hashtags:
            return "/api/search/all/hashtag-search"
        case .hashtagCards(let hashtagIdPath, _, _):
            // 서버 스펙: path + query 해시태그 ID 모두 요구
            return "/api/search/all/hashtag-cards/\(hashtagIdPath)"
        }
    }

    var method: Moya.Method { .get }

    var task: Task {
        switch self {
        case let .accounts(query, limit, cursor):
            var params: [String: Any] = ["query": query]
            if let limit { params["limit"] = limit }
            if let cursor { params["cursor"] = cursor }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)

        case let .hashtags(query, limit, cursor):
            var params: [String: Any] = ["query": query]
            if let limit { params["limit"] = limit }
            if let cursor { params["cursor"] = cursor }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)

        case let .hashtagCards(_, hashtagIdQuery, limit):
            var params: [String: Any] = ["hashtagId": hashtagIdQuery]
            if let limit { params["limit"] = limit }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}


// MARK: - Models
struct ExploreCard: Identifiable, Equatable {
    let id: Int
    let imageURL: URL
    let commentCount: Int
    let reactionCount: Int
}

struct AccountSummary: Hashable, Sendable, Identifiable {
    var id: Int { userId }
    var userId: Int
    var nameId: String
    var nickname: String
    var profileImageURL: String?
}

struct HashtagSummary: Hashable, Sendable {
    let hashtagId: Int
    let title: String
    let postCount: Int
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

// MARK: - Search DTOs
struct SearchAccountsResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ResultPayload

    struct ResultPayload: Decodable {
        let accounts: [AccountDTO]
        let nextCursor: Int?
        let size: Int
        let hasNext: Bool
    }
}

struct AccountDTO: Decodable {
    let userId: Int
    let nameId: String
    let nickname: String
    let profileImageURL: String?

    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nameId = "name_id"
        case nickname
        case profileImageURL = "profile_image_url"
    }
}

extension AccountDTO {
    func toDomain() -> AccountSummary {
        AccountSummary(
            userId: userId,
            nameId: nameId,
            nickname: nickname,
            profileImageURL: profileImageURL
        )
    }
}

struct SearchHashtagsResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ResultPayload

    struct ResultPayload: Decodable {
        let hashtags: [HashtagDTO]
        let nextCursor: Int?
        let size: Int
        let hasNext: Bool
    }
}

struct HashtagDTO: Decodable {
    let hashtagId: Int
    let title: String
    let postCount: Int

    private enum CodingKeys: String, CodingKey {
        case hashtagId = "hashtag_id"
        case title = "hashtag_name"
        case postCount = "card_count"
    }
}

extension HashtagDTO {
    func toDomain() -> HashtagSummary {
        HashtagSummary(
            hashtagId: hashtagId,
            title: title,
            postCount: postCount
        )
    }
}

// MARK: - Repository
protocol ExploreRepository {
    func fetchCards(limit: Int) async throws -> [ExploreCard]
    func searchAccounts(
        query: String, limit: Int?, cursor: Int?
    ) async throws -> (items: [AccountSummary], nextCursor: Int?, hasNext: Bool)
    func searchHashtags(
        query: String, limit: Int?, cursor: Int?
    ) async throws -> (items: [HashtagSummary], nextCursor: Int?, hasNext: Bool)
    func fetchCardsByHashtag(
        hashtagId: Int, limit: Int?, cursor: Int?
    ) async throws -> (items: [ExploreCard], nextCursor: Int?, hasNext: Bool)
}

final class ExploreRepositoryImpl: ExploreRepository {
    private let exploreProvider: MoyaProvider<ExploreAPITarget>
    private let searchProvider: MoyaProvider<SearchAPITarget>

    init(
        container: DIContainer
    ) {
        self.exploreProvider = container.apiProviderStore.explore()
        self.searchProvider = container.apiProviderStore.search()
    }

    func fetchCards(limit: Int) async throws -> [ExploreCard] {
        let response = try await exploreProvider.asyncRequest(.search(limit: limit))
        let decoded = try JSONDecoder().decode(ExploreSearchResponseDTO.self, from: response.data)
        return decoded.result.cards.map { $0.toDomain() }
    }

    func searchAccounts(
        query: String, limit: Int?, cursor: Int?
    ) async throws -> (items: [AccountSummary], nextCursor: Int?, hasNext: Bool) {
        let res = try await searchProvider.asyncRequest(
            .accounts(query: query, limit: limit, cursor: cursor))
        let decoded = try JSONDecoder().decode(SearchAccountsResponseDTO.self, from: res.data)
        return (decoded.result.accounts.map { $0.toDomain() },
                decoded.result.nextCursor, decoded.result.hasNext)
    }

    func searchHashtags(
        query: String, limit: Int?, cursor: Int?
    ) async throws -> (items: [HashtagSummary], nextCursor: Int?, hasNext: Bool) {
        let res = try await searchProvider.asyncRequest(
            .hashtags(query: query, limit: limit, cursor: cursor))
        let decoded = try JSONDecoder().decode(SearchHashtagsResponseDTO.self, from: res.data)
        return (decoded.result.hashtags.map { $0.toDomain() },
                decoded.result.nextCursor, decoded.result.hasNext)
    }

    func fetchCardsByHashtag(
        hashtagId: Int, limit: Int?, cursor: Int?
    ) async throws -> (items: [ExploreCard], nextCursor: Int?, hasNext: Bool) {
        let res = try await searchProvider.asyncRequest(
            .hashtagCards(hashtagIdPath: hashtagId, hashtagIdQuery: hashtagId, limit: limit))
        let decoded = try JSONDecoder().decode(HashtagCardsResponseDTO.self, from: res.data)
        return (decoded.result.cards.map { $0.toDomain() },
                decoded.result.nextCursor, decoded.result.hasNext)
    }
}

// MARK: - ViewModel
@MainActor
final class ExploreViewModel: ObservableObject {
    @Published private(set) var cards: [ExploreCard] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil

    // Search states
    @Published private(set) var accounts: [AccountSummary] = []
    @Published private(set) var hashtags: [HashtagSummary] = []
    @Published private(set) var isLoadingAccounts = false
    @Published private(set) var isLoadingHashtags = false
    @Published private(set) var hasNextAccounts = false
    @Published private(set) var hasNextHashtags = false
    
    @Published var didLoadSearchOnce = false
    
    private let repository: ExploreRepository
    private var nextCursorAccounts: Int? = nil
    private var nextCursorHashtags: Int? = nil
    private var currentQuery: String = ""
    
//    private var searchTask: Task? = nil

    init(container: DIContainer) {
        self.repository = ExploreRepositoryImpl(container: container)
    }

    // Initial explore feed
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

    // Update query with 300ms debounce and cancel in-flight
    func updateQuery(_ query: String) async {
        currentQuery = query
//        searchTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            // reset results if query too short
            accounts = []
            hashtags = []
            nextCursorAccounts = nil
            nextCursorHashtags = nil
            hasNextAccounts = false
            hasNextHashtags = false
            return
        }
        
        await search(query: trimmed)
    }

    private func search(query: String) async {
        isLoadingAccounts = true
        isLoadingHashtags = true
        nextCursorAccounts = nil
        nextCursorHashtags = nil
        defer {
            isLoadingAccounts = false
            isLoadingHashtags = false
        }

        do {
            let acc = try await repository.searchAccounts(
                query: query, limit: 20, cursor: nil)
            self.accounts = acc.items
            self.nextCursorAccounts = acc.nextCursor
            self.hasNextAccounts = acc.hasNext
        } catch {
            self.accounts = []
            self.nextCursorAccounts = nil
            self.hasNextAccounts = false
            errorMessage = error.localizedDescription
            print("errorMessage: \(String(describing: errorMessage))")
        }
        
        do {
            let hashtag = try await repository.searchHashtags(
                query: query, limit: 20, cursor: nil)
            self.hashtags = hashtag.items
            self.nextCursorHashtags = hashtag.nextCursor
            self.hasNextHashtags = hashtag.hasNext
        } catch {
            self.hashtags = []
            self.nextCursorHashtags = nil
            self.hasNextHashtags = false
            errorMessage = error.localizedDescription
            print("errorMessage: \(String(describing: errorMessage))")
        }

        self.didLoadSearchOnce = true
    }

    var isEmptyResults: Bool {
        accounts.isEmpty && hashtags.isEmpty
    }

    func loadMoreAccounts() async {
        guard hasNextAccounts, let cursor = nextCursorAccounts else { return }
        isLoadingAccounts = true
        defer { isLoadingAccounts = false }
        do {
            let more = try await repository.searchAccounts(
                query: currentQuery, limit: 20, cursor: cursor)
            self.accounts.append(contentsOf: more.items)
            self.nextCursorAccounts = more.nextCursor
            self.hasNextAccounts = more.hasNext
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func loadMoreHashtags() async {
        guard hasNextHashtags, let cursor = nextCursorHashtags else { return }
        isLoadingHashtags = true
        defer { isLoadingHashtags = false }
        do {
            let more = try await repository.searchHashtags(
                query: currentQuery, limit: 20, cursor: cursor)
            self.hashtags.append(contentsOf: more.items)
            self.nextCursorHashtags = more.nextCursor
            self.hasNextHashtags = more.hasNext
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // Load feed by hashtag id (tap action)
    func fetchHashtagFeed(hashtagId: Int, limit: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await repository.fetchCardsByHashtag(
                hashtagId: hashtagId, limit: limit, cursor: nil)
            self.cards = result.items
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
