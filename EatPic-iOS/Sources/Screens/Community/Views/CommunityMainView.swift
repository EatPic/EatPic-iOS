//
//  CommunityMainView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/22/25.
//

import SwiftUI

struct CommunityMainView: View {
    
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel: CommunityMainViewModel
    
    init(container: DIContainer) {
        self._viewModel = StateObject(wrappedValue: container.getCommunityMainVM())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                userListView()
                cardListView()
                lastContentView()
            }
        }
        .scrollIndicators(.hidden)
        .toastView(viewModel: viewModel.toastVM)
        .padding(.horizontal, 16)
        .overlay {
            if viewModel.showDeleteModal {
                DecisionModalView(
                    message: "Pic카드를 정말 삭제하시겠어요?",
                    messageColor: .gray080,
                    leftBtnText: "취소",
                    rightBtnText: "삭제",
                    rightBtnColor: .red050,
                    leftBtnAction: {
                        viewModel.showDeleteModal = false
                    },
                    rightBtnAction: {
                        Task { await viewModel.confirmDeletion() }
                    }
                )
            }
        }
        .sheet(isPresented: $viewModel.isShowingReportBottomSheet) {
            ReportBottomSheetView(
                isShowing: $viewModel.isShowingReportBottomSheet,
                onReport: viewModel.handleReport,
                target: .picCard
            )
            .presentationDetents([.large, .fraction(0.7)])
            .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $viewModel.isShowingCommentBottomSheet) {
            CommentBottomSheetView(
                isShowing: $viewModel.isShowingCommentBottomSheet,
                viewModel: viewModel.commentVM
            )
            .presentationDetents([.large, .fraction(0.7)])
            .presentationDragIndicator(.hidden)
        }
    }
    
    private func userListView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.users) { user in
                    VStack(spacing: 16) {
                        if user.userType == .all {
                            let imageName = viewModel.selectedUser?.id == user.id
                            ? "Community/grid_selected"
                            : "Community/grid"
                            ProfileImageView(
                                image: imageName,
                                size: 64,
                                borderColor: user == viewModel.selectedUser ? .pink050 : .gray040,
                                borderWidth: 3
                            )
                        } else {
                            ProfileImageView(
                                image: user.imageName,
                                size: 64,
                                borderColor: user == viewModel.selectedUser ? .pink050 : .gray040,
                                borderWidth: 3
                            )
                        }
                        
                        Text(user.userType == .me ? "나" : user.nameId)
                            .font(.dsSubhead)
                            .foregroundStyle(Color.gray080)
                    }
                    .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 2))
                    .onTapGesture {
                        Task {
                            await viewModel.selectUser(user)
                        }
                    }
                }
            }
            .frame(maxHeight: 112)
        }
        .scrollIndicators(.hidden)
        .task { await viewModel.fetchUserList() }
    }
    
    private func cardListView() -> some View {
        LazyVStack(spacing: 32) {
            ForEach(viewModel.filteredCards) { card in
                MainPicCardView(
                    card: card,
                    menuContent: {
                        if viewModel.isMyCard(card) {
                            Button(action: { viewModel.saveCardToPhotos(card) }) {
                                Label("사진 앱에 저장", systemImage: "arrow.down.to.line")
                            }
                            Button(action: { viewModel.editCard(card) }) {
                                Label("수정하기", systemImage: "square.and.pencil")
                            }
                            Button(role: .destructive, action: {
                                viewModel.showDeleteConfirmation(for: card)
                            }) {
                                Label("삭제하기", systemImage: "trash")
                            }
                        } else {
                            Button(role: .destructive, action: {
                                viewModel.isShowingReportBottomSheet = true
                            }) {
                                Label("신고하기", systemImage: "exclamationmark.bubble")
                            }
                        }
                    },
                    onProfileTap: {
                        container.router.push(.userProfile(user: card.user))
                    },
                    onLocationTap: { latitude, longitude, locationText in
                        container.router.push(
                            .storeLocation(
                                latitude: latitude,
                                longitude: longitude,
                                title: locationText
                            )
                        )
                    },
                    toastVM: viewModel.toastVM,
                    onItemAction: { cardId, action in
                        Task { await viewModel.handleCardAction(cardId: cardId, action: action) }
                    }
                )
            }
        }
        // 최초/탭 포그라운드/탭 활성화 시 새로고침
        .task { await viewModel.refreshFeeds(reset: true) }
        .task(id: container.activeTab) {
            guard container.activeTab == .community else { return }
            await viewModel.refreshFeeds(reset: false)
        }
        .task(id: container.foregroundRefreshTick) {
            guard container.activeTab == .community else { return }
            await viewModel.refreshFeeds(reset: false)
        }
        .refreshable { await viewModel.refreshFeeds(reset: true) }
    }
    
    private func lastContentView() -> some View {
        VStack {
            Spacer().frame(height: 8)
            Text("👏🏻").font(.dsLargeTitle)
            Spacer().frame(height: 19)
            Text("7일 간의 Pic카드를 모두 다 보셨군요!").font(.dsBold15)
            Spacer().frame(height: 8)
            Text("내일도 잇픽에서 잇친들의 Pic카드를 확인해보세요.").font(.dsFootnote)
            Spacer()
        }
        .frame(height: 157)
    }
}

// 카드 하단 인터페이스(북마크/댓글/리액션)
struct MainPicCardItemView: View {
    let card: PicCard
    let toastVM: ToastViewModel
    var onAction: ((MainPicCardItemActionType) -> Void)?
    
    // UI 제어용 로컬 상태(도메인 상태 미러링 금지)
    @State private var isShowingReactionBar: Bool = false
    @State private var isShowingCommentSheet: Bool = false
    @State private var localSelectedReaction: MainReactionType? = nil
    @State private var localReactionCounts: [MainReactionType: Int] = [:]
    
    init(
        card: PicCard,
        toastVM: ToastViewModel,
        onAction: ((MainPicCardItemActionType) -> Void)? = nil
    ) {
        self.card = card
        self.toastVM = toastVM
        self.onAction = onAction
    }
    
    private var items: [MainPicCardItemType] {
        [
            .bookmark(card.bookmarked),
            .comment(card.commentCount),
            .reaction(
                selected: MainReactionType(rawValue: card.userReaction ?? ""),
                totalCount: card.reactionCount
            )
        ]
    }
    
    var body: some View {
        if isShowingReactionBar {
            Color.black.opacity(0.001)
                .onTapGesture {
                    withAnimation { isShowingReactionBar = false }
                }
            
            MainReactionBarView(
                selectedReaction: Binding(
                    get: {
                        localSelectedReaction
                        ?? MainReactionType(
                            rawValue: card.userReaction ?? "") },
                    set: { localSelectedReaction = $0 }
                ),
                reactionCounts: $localReactionCounts,
                onReactionSelected: { reaction in
                    handleReactionSelection(reaction)
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        } else {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(items, id: \.id) { item in
                    HStack(spacing: 8) {
                        Button {
                            handleTap(for: item)
                        } label: {
                            item.icon
                        }
                        if let count = item.count {
                            Text(count > 999 ? "999+" : "\(count)")
                                .font(.dsHeadline)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(16)
        }
    }
    
    private func handleTap(for item: MainPicCardItemType) {
        switch item {
        case .bookmark:
            onAction?(.bookmark(isOn: !card.bookmarked))
            if !card.bookmarked {
                toastVM.showToast(title: "Pic 카드가 저장되었습니다.")
            }
        case .comment:
            onAction?(.comment(count: card.commentCount))
        case .reaction:
            withAnimation { isShowingReactionBar = true }
        }
    }
    
    private func handleReactionSelection(_ reaction: MainReactionType?) {
        let previous = localSelectedReaction
        localSelectedReaction = reaction
        updateReactionCounts(previous: previous, new: reaction)
        onAction?(.reaction(selected: reaction, counts: localReactionCounts))
    }
    
    private func updateReactionCounts(previous: MainReactionType?, new: MainReactionType?) {
        if let prev = previous {
            localReactionCounts[prev] = max(0, (localReactionCounts[prev] ?? 0) - 1)
        }
        if let new = new {
            localReactionCounts[new] = (localReactionCounts[new] ?? 0) + 1
        }
    }
}

struct MainPicCardView<Content: View>: View {
    let card: PicCard
    let menuContent: () -> Content
    let onProfileTap: (() -> Void)?
    let onLocationTap: ((Double, Double, String) -> Void)?
    let toastVM: ToastViewModel
    let onItemAction: ((Int, MainPicCardItemActionType) -> Void)?
    
    @State private var isFlipped = false
    
    init(
        card: PicCard,
        @ViewBuilder menuContent: @escaping () -> Content,
        onProfileTap: (() -> Void)? = nil,
        onLocationTap: ((Double, Double, String) -> Void)? = nil,
        toastVM: ToastViewModel,
        onItemAction: ((Int, MainPicCardItemActionType) -> Void)? = nil
    ) {
        self.card = card
        self.menuContent = menuContent
        self.onProfileTap = onProfileTap
        self.onLocationTap = onLocationTap
        self.toastVM = toastVM
        self.onItemAction = onItemAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 상단: 프로필/시간/메뉴
            HStack {
                if let profileImage = card.user.profileImage {
                    profileImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .onTapGesture { onProfileTap?() }
                } else {
                    Image(.Community.itcong)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .onTapGesture { onProfileTap?() }
                }
                
                VStack(alignment: .leading) {
                    Text(card.user.nameId)
                        .font(.dsHeadline)
                        .foregroundStyle(Color.gray080)
                    Text(card.time)
                        .font(.dsFootnote)
                        .foregroundStyle(Color.gray060)
                }
                
                Spacer()
                
                Menu { menuContent() } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 24, height: 5)
                        .foregroundStyle(Color.black)
                        .padding(.trailing, 2)
                        .padding([.leading, .top, .bottom], 16)
                        .contentShape(Rectangle())
                }
            }
            .highPriorityGesture(
                TapGesture().onEnded { onProfileTap?() }
            )
            
            // 앞/뒷면 전환
            ZStack {
                if !isFlipped {
                    MainPicCardFrontView(
                        card: card,
                        toastVM: toastVM
                    ) { action in
                        onItemAction?(card.cardId, action)
                    } onFlip: {
                        withAnimation { isFlipped.toggle() }
                    }
                } else {
                    MainPicCardBackView(
                        card: card,
                        onLocationTap: onLocationTap
                    )
                    .contentShape(Rectangle())
                    .onTapGesture { withAnimation { isFlipped.toggle() } }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            
            // 메모
            Text(card.memo)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray080)
                .frame(alignment: .leading)
        }
    }
}

// MainPicCardFrontView
struct MainPicCardFrontView: View {
    let card: PicCard
    let toastVM: ToastViewModel
    let onItemAction: ((MainPicCardItemActionType) -> Void)?
    let onFlip: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .remoteImage(url: card.imageUrl)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                MainPicCardItemView(
                    card: card,
                    toastVM: toastVM
                ) { action in onItemAction?(action) }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            // 히트 영역을 카드 사각형으로 한정
            .contentShape(Rectangle())
            .onTapGesture { onFlip() }
        }
    }
}

struct MainPicCardBackView: View {
    let card: PicCard
    let onLocationTap: ((Double, Double, String) -> Void)?
    
    var body: some View {
        RecipeDetailCardView(
            backgroundImage: card.imageUrl,
            hashtags: card.hashtags ?? [],
            recipeDescription: card.recipe ?? "레시피 정보가 없습니다.",
            linkURL: card.recipeUrl,
            naviButtonAction: {
                if let latitude = card.latitude,
                   let longitude = card.longitude,
                   let locationText = card.locationText {
                    onLocationTap?(latitude, longitude, locationText)
                } else {
                    print("위치 정보 없음")
                }
            },
            naviLabel: card.locationText
        )
    }
}

// MARK: - 기타 타입들

enum MainPicCardItemType {
    case bookmark(Bool)
    case comment(Int)
    case reaction(selected: MainReactionType?, totalCount: Int)
    
    var id: String {
        switch self {
        case .bookmark: return "bookmark"
        case .comment: return "comment"
        case .reaction: return "reaction"
        }
    }
    
    @ViewBuilder
    var icon: some View {
        switch self {
        case .bookmark(let isBookmarked):
            Image(isBookmarked ? "icon_bookmark_selected" : "icon_bookmark")
        case .comment:
            Image("icon_comment")
        case .reaction(let selected, _):
            if let emoji = selected?.emoji {
                Text(emoji)
                    .font(.dsHeadline)
                    .background(alignment: .center) {
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                    }
                    .padding(8)
            } else {
                Image("icon_emotion")
            }
        }
    }
    
    var count: Int? {
        switch self {
        case .bookmark: return nil
        case .comment(let value): return value
        case .reaction(_, let totalCount): return totalCount
        }
    }
}

enum MainPicCardItemActionType {
    case bookmark(isOn: Bool)
    case comment(count: Int)
    case reaction(selected: MainReactionType?, counts: [MainReactionType: Int])
}

enum MainReactionType: String, CaseIterable, Identifiable, Codable {
    case thumbsUp = "THUMB_UP"
    case heart = "HEART"
    case yummy = "YUMMY"
    case power = "POWER"
    case laugh = "LAUGH"
    
    var id: String { rawValue }
    var emoji: String {
        switch self {
        case .thumbsUp: return "👍🏻"
        case .heart:    return "❤️"
        case .yummy:    return "😋"
        case .power:    return "💪🏻"
        case .laugh:    return "🤣"
        }
    }
}

struct MainReactionBarView: View {
    @Binding var selectedReaction: MainReactionType?
    @Binding var reactionCounts: [MainReactionType: Int]
    var onReactionSelected: (MainReactionType?) -> Void
    
    init(
        selectedReaction: Binding<MainReactionType?>,
        reactionCounts: Binding<[MainReactionType: Int]>,
        onReactionSelected: @escaping (MainReactionType?) -> Void = { _ in }
    ) {
        self._selectedReaction = selectedReaction
        self._reactionCounts = reactionCounts
        self.onReactionSelected = onReactionSelected
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(MainReactionType.allCases) { reaction in
                Button {
                    toggleReaction(reaction)
                } label: {
                    VStack(spacing: 1) {
                        Text(reaction.emoji).font(.dsHeadline)
                        Text(countText(for: reaction))
                            .font(.dsCaption2)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 6)
                .padding(.bottom, 3)
                .background(alignment: .center) {
                    Circle()
                        .fill(
                            selectedReaction == reaction
                            ? Color.pink060
                            : Color.black.opacity(0.8))
                        .frame(width: 40, height: 40)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .padding(.horizontal, 48)
        .padding(.bottom, 16)
    }
    
    private func toggleReaction(_ reaction: MainReactionType) {
        let newReaction: MainReactionType?
        if selectedReaction == reaction {
            selectedReaction = nil
            reactionCounts[reaction, default: 1] -= 1
            newReaction = nil
        } else {
            if let previous = selectedReaction {
                reactionCounts[previous, default: 1] -= 1
            }
            selectedReaction = reaction
            reactionCounts[reaction, default: 0] += 1
            newReaction = reaction
        }
        onReactionSelected(newReaction)
    }
    
    private func countText(for reaction: MainReactionType) -> String {
        let count = reactionCounts[reaction, default: 0]
        return count > 99 ? "99+" : "\(count)"
    }
}

struct CommunityUser: Identifiable, Hashable, Equatable {
    let id: Int
    let nameId: String
    let nickname: String
    let imageName: String?
    var profileImage: Image? { imageName.map { Image($0) } }
    let introduce: String?
    let userType: CommunityUserType
    let isCurrentUser: Bool
    var isFollowed: Bool
    
    init(id: Int, nameId: String, nickname: String,
         imageName: String?, introduce: String? = nil,
         type: CommunityUserType = .other,
         isCurrentUser: Bool = false,
         isFollowed: Bool = true) {
        self.id = id
        self.nameId = nameId
        self.nickname = nickname
        self.imageName = imageName
        self.introduce = introduce
        self.userType = type
        self.isCurrentUser = isCurrentUser
        self.isFollowed = isFollowed
    }
}

enum CommunityUserType { case all, me, other }

struct PicCard: Identifiable, Equatable {
    // 안정적인 식별자: 백엔드 id와 동일
    var id: Int { cardId }
    let cardId: Int
    let user: CommunityUser
    let time: String
    let memo: String
    
    // 스웨거 필드
    let imageUrl: String
    let date: String
    let meal: MealSlot
    let recipe: String?
    let recipeUrl: URL?
    let latitude: Double?
    let longitude: Double?
    let locationText: String?
    let hashtags: [String]?
    
    // 상태성 필드
    var reactionCount: Int
    var userReaction: String?
    var commentCount: Int
    var bookmarked: Bool
    
    static func == (lhs: PicCard, rhs: PicCard) -> Bool { lhs.cardId == rhs.cardId }
}

struct Comment: Identifiable {
    let id: Int
    let user: CommunityUser
    let text: String
    let time: String
}

#Preview {
    CommunityMainView(container: .init())
        .environmentObject(DIContainer())
}
