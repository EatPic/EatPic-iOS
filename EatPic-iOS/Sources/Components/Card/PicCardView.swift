//
//  PicCardView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/12/25.
//

import SwiftUI

/// - Parameters:
///   - card: 픽카드 데이터
///   - menuContent: 메뉴버튼(eclipsis) 클릭 시 나타날 버튼목록 커스텀
///   - onProfileTap: 프로필 탭 시 프로필뷰로 이동하는 클로저
///   - onLocationTap: 위치 버튼 탭 시 지도 뷰로 이동하는 클로저
///   - toastVM: 토스트 메시지 뷰모델
///   - onItemAction: 카드 아이템 액션 콜백
struct PicCardView<Content: View>: View {
    
    // MARK: - property
    let card: PicCard
    let menuContent: () -> Content
    let onProfileTap: (() -> Void)?
    let onLocationTap: ((Double, Double, String) -> Void)?
    let toastVM: ToastViewModel
    let onItemAction: ((UUID, PicCardItemActionType) -> Void)? //카드 ID 전달 추가
    
    @State private var isFlipped = false
    
    // MARK: - init
    init(
        card: PicCard,
        @ViewBuilder menuContent: @escaping () -> Content,
        onProfileTap: (() -> Void)? = nil,
        onLocationTap: ((Double, Double, String) -> Void)? = nil,
        toastVM: ToastViewModel,
        onItemAction: ((UUID, PicCardItemActionType) -> Void)? = nil
    ) {
        self.card = card
        self.menuContent = menuContent
        self.onProfileTap = onProfileTap
        self.onLocationTap = onLocationTap
        self.toastVM = toastVM
        self.onItemAction = onItemAction
    }
    
    // MARK: - body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 카드 상단 업로드 정보(프로필, 시간)
            HStack {
                if let profileImage = card.user.profileImage {
                    profileImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .onTapGesture { onProfileTap?() }
                } else {
                    Image(systemName: "person.circle.fill") // 기본 이미지로 대체
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .onTapGesture { onProfileTap?() }
                }
                
                VStack(alignment: .leading) {
                    Text(card.user.id)
                        .font(.dsHeadline)
                        .foregroundStyle(Color.gray080)
                    Text(card.time)
                        .font(.dsFootnote)
                        .foregroundStyle(Color.gray060)
                }
                
                Spacer()
                
                Menu {
                    menuContent()
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 24, height: 5)
                        .foregroundStyle(Color.black)
                        .padding(.trailing, 2)
                        .padding([.leading, .top, .bottom], 16) // 실제 터치 영역 넓히기
                        .contentShape(Rectangle()) // 패딩 영역까지 터치 인식
                }
            }
            
            // 이미지와 레시피 상세 뷰를 조건부로 렌더링하고 애니메이션 적용
            ZStack {
                if !isFlipped {
                    // 카드 앞면 (이미지)
                    PicCardFrontView(card: card, toastVM: toastVM) { action in
                        onItemAction?(card.id, action)
                    } 
                } else {
                    // 카드 뒷면 (레시피)
                    PicCardBackView(card: card, onLocationTap: onLocationTap)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: isFlipped)
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }
            .aspectRatio(1, contentMode: .fit)
            
            // 사용자 메모
            Text(card.memo)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray080)
                .frame(alignment: .leading)
        }
    }
}

// MARK: - PicCardView의 앞면 (기존 postImage와 아이템뷰)
struct PicCardFrontView: View {
    let card: PicCard
    let toastVM: ToastViewModel
    let onItemAction: ((PicCardItemActionType) -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                card.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                PicCardItemView(card: card, toastVM: toastVM, onAction: onItemAction)
                    .frame(maxWidth: .infinity, maxHeight: .infinity,
                           alignment: .bottomLeading)
            }
        }
    }
}

// MARK: - PicCardView의 뒷면 (레시피 상세 뷰)
struct PicCardBackView: View {
    let card: PicCard
    let onLocationTap: ((Double, Double, String) -> Void)?
    
    var body: some View {
        RecipeDetailCardView(
            backgroundImage: card.image,
            hashtags: card.hashtags ?? [],
            recipeDescription: card.recipe ?? "레시피 정보가 없습니다.",
            linkURL: card.recipeUrl,
            naviButtonAction: {
                print("내비게이션 버튼 탭")
                // 옵셔널 바인딩을 사용하여 안전하게 값 언래핑
                if let latitude = card.latitude,
                   let longitude = card.longitude,
                   let locationText = card.locationText {
                    
                    // 옵셔널 바인딩에 성공하면 클로저를 실행
                    onLocationTap?(latitude, longitude, locationText)
                    
                } else {
                    // 위치 정보가 없을 경우 처리
                    print("위치 정보가 없어 내비게이션을 실행할 수 없습니다.")
                }
            },
            naviLabel: card.locationText
        )
    }
}
