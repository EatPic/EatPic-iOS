//
//  ExploreSelectedView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/31/25.
//

import SwiftUI


struct ExploreSelectedView: View {
    
    @EnvironmentObject private var container: DIContainer
    @State private var viewModel: ExploreSelectedViewModel
    @Bindable private var toastVM = ToastViewModel()
    
    @State private var showAlert: Bool = false
    
    private let cardId: Int
    
    init(
        cardId: Int,
        container: DIContainer
    ) {
        self.cardId = cardId
        self._viewModel = State(wrappedValue: .init(container: container))
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0), spacing: 9.5),
        GridItem(.flexible(minimum: 0), spacing: 9.5)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 51) {
                if let picCard = viewModel.picCard {
                    selectedPicCardView(card: picCard)
                }
                recommendedFeedView()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .scrollIndicators(.hidden)
        .task {
            await viewModel.fetchCardDetail(cardId: cardId)
            await viewModel.fetchRecommendedCards()
        }
        .onChange(of: viewModel.errMsg) { _, newValue in
            if newValue != nil {
                showAlert = true
            }
        }
        .alert(
            "상세 카드를 불러오는데 실패했습니다.",
            isPresented: $showAlert,
            actions: {
                Button("확인", role: .cancel) {
                    container.router.pop()
                }
            },
            message: {
                Text(viewModel.errMsg ?? "")
            }
        )
        .customCenterNavigationBar(title: {
            Text("탐색")
                .font(.dsTitle2)
                .foregroundStyle(Color.white)
        })
    }
    
    private func selectedPicCardView(card: PicCard) -> some View {
        return PicCardView(
            card: card,
            menuContent: {
                Button(role: .destructive, action: {
                    print("신고하기")
                }, label: {
                    Label("신고하기", systemImage: "exclamationmark.bubble")
                })
            },
            onProfileTap: {
                print("프로필로 이동")
            },
            toastVM: toastVM,
            onItemAction: nil // 필요에 따라 구현하거나 nil로 둡니다.
        )
    }
    
    private func recommendedFeedView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("더 찾아보기")
                .font(.dsTitle3)
                .foregroundStyle(.black)
            
            LazyVGrid(columns: columns, spacing: 9, content: {
                ForEach(viewModel.recommended, id: \.id) { card in
                    ExplorePicCardView(
                        imageURL: card.imageURL,
                        commentCount: card.commentCount,
                        reactionCount: card.reactionCount
                    )
                }
            })
        }
    }
}

/// 각 피드 카드 뷰: 게시물 이미지 + 댓글/공감 수
struct ExplorePicCardView: View {
    private let imageURL: URL
    private let commentCount: Int
    private let reactionCount: Int
    
    init(imageURL: URL, commentCount: Int, reactionCount: Int) {
        self.imageURL = imageURL
        self.commentCount = commentCount
        self.reactionCount = reactionCount
    }
    
    var body: some View {
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

                // Bottom gradient for legibility
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.35), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .allowsHitTesting(false)
                
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

#Preview {
    ExploreSelectedView(cardId: 1, container: .init())
}

import Foundation

struct CardDetailResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CardDetail
}

struct CardDetail: Decodable {
    let cardId: Int
    let imageUrl: String
    let datetime: String
    let meal: String
    let memo: String
    let recipe: String?
    let recipeUrl: String?
    let latitude: Double?
    let longitude: Double?
    let locationText: String?
    let hashtags: [String]
    let user: CardDetailUser
    let reactionCount: Int
    let userReaction: String?
    let commentCount: Int
    let bookmarked: Bool
}

struct CardDetailUser: Decodable {
    let userId: Int
    let nameId: String
    let nickname: String
    let profileImageUrl: String?
}

// MARK: - Mapping DTO -> Domain

extension CardDetail {
    func toPicCard() -> PicCard {
        let userDomain = user.toCommunityUser()
        
        // 서버는 "yyyy-MM-dd HH:mm:ss" 문자열을 내려줌.
        // 현재 PicCard는 time/date가 String이므로 우선 동일 값으로 매핑해두고,
        // 추후 포매팅 함수로 분리 가능.
        let timeString = datetime
        let dateString = datetime
        
        let mealSlot = MealSlot(serverValue: meal) ?? .LUNCH
        
        return PicCard(
            cardId: cardId,
            user: userDomain,
            time: timeString,
            memo: memo,
            imageUrl: imageUrl,
            date: dateString,
            meal: mealSlot,
            recipe: recipe,
            recipeUrl: recipeUrl.flatMap { URL(string: $0) },
            latitude: latitude,
            longitude: longitude,
            locationText: locationText,
            hashtags: hashtags,
            reactionCount: reactionCount,
            userReaction: userReaction,
            commentCount: commentCount,
            bookmarked: bookmarked
        )
    }
}

extension CardDetailUser {
    func toCommunityUser() -> CommunityUser {
        // 현재 CommunityUser는 원격 URL 프로필 이미지를 직접 들고 있지 않으므로
        // imageName은 nil로 두고, 실제 UI단에서 URL 이미지를 지원하게 되면 모델을 확장하세요.
        CommunityUser(
            id: userId,
            nameId: nameId,
            nickname: nickname,
            imageName: nil,
            introduce: nil,
            type: .other,
            isCurrentUser: false,
            isFollowed: true
        )
    }
}

// MARK: - Server value helpers

extension MealSlot {
    /// 서버에서 내려오는 문자열(BREAKFAST/LUNCH/DINNER/SNACK)을 앱의 MealSlot로 매핑
    init?(serverValue: String) {
        switch serverValue.uppercased() {
        case "BREAKFAST": self = .BREAKFAST
        case "LUNCH":     self = .LUNCH
        case "DINNER":    self = .DINNER
        case "SNACK":     self = .SNACK
        default:          return nil
        }
    }
}

import Moya

@Observable
final class ExploreSelectedViewModel {
    private(set) var picCard: PicCard?
    private(set) var errMsg: String?
    private let cardProvider: MoyaProvider<CardTargetType>
    private let exploreRepository: ExploreRepository
    private(set) var recommended: [ExploreCard] = []
    
    init(container: DIContainer) {
        cardProvider = container.apiProviderStore.card()
        self.exploreRepository = ExploreRepositoryImpl(container: container)
    }

    func fetchCardDetail(cardId: Int) async {
        do {
            let response = try await cardProvider.requestAsync(.fetchCardDetail(cardId: cardId))
            let dto = try JSONDecoder().decode(CardDetailResponse.self, from: response.data)
            
            await MainActor.run {
                picCard = dto.result.toPicCard()
            }
        } catch {
            print("Failed to fetch card detail: \(error)")
            errMsg = error.localizedDescription
        }
    }
    
    func fetchRecommendedCards() async {
        do {
            // 더 찾아보기 뷰에 대한 api가 없는 관계로 `api/search` api로 대체함
            let items = try await exploreRepository.fetchCards(limit: 20)
            
            await MainActor.run {
                self.recommended = items
            }
        } catch {
            print("Failed to fetch recommended cards: \(error)")
            errMsg = "추천 피드를 불러오지 못했습니다. 잠시 후 다시 시도해주세요."
        }
    }
}
