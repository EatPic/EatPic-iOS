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
///   - toastVM: 토스트 메시지 뷰모델
///   - onItemAction: 카드 아이템 액션 콜백
struct PicCardView<Content: View>: View {
    
    // MARK: - property
    let card: PicCard
    let menuContent: () -> Content
    let onProfileTap: (() -> Void)?
    let toastVM: ToastViewModel
    let onItemAction: ((PicCardItemActionType) -> Void)?
    
    @State private var isFlipped = false // 카드의 뒤집힌 상태를 관리하는 변수
    
    // MARK: - init
    init(
        card: PicCard,
        @ViewBuilder menuContent: @escaping () -> Content,
        onProfileTap: (() -> Void)? = nil,
        toastVM: ToastViewModel,
        onItemAction: ((PicCardItemActionType) -> Void)? = nil
    ) {
        self.card = card
        self.menuContent = menuContent
        self.onProfileTap = onProfileTap
        self.toastVM = toastVM
        self.onItemAction = onItemAction
    }
    
    // MARK: body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 카드 상단 업로드 정보(프로필, 시간)
            HStack {
                card.user.profileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .onTapGesture {
                        onProfileTap?()
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
                    PicCardFrontView(card: card, toastVM: toastVM, onItemAction: onItemAction)
                        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                } else {
                    // 카드 뒷면 (레시피)
                    PicCardBackView(card: card)
                        .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0.0, y: 1.0, z: 0.0))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: isFlipped)
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }
            .aspectRatio(1, contentMode: .fit)
            
            // 사용자 메모 (나의 메모)
            Text(card.memo)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray080)
                .frame(alignment: .leading)
        }
    }
}

#Preview {
    CommunityMainView()
}

#Preview {
    PicCardView(
        profileImage: Image(systemName: "circle.fill"),
        profileID: "아이디",
        time: "오후 6:29",
        menuContent: {
            Button(action: {
                print("사진 앱에 저장")
            }, label: {
                Label("사진 앱에 저장", systemImage: "square.and.arrow.down")
            })
            
            Button(action: {
                print("수정하기")
            }, label: {
                Label("수정하기", systemImage: "square.and.pencil")
            })
            
            // role을 destructive로 설정 시, 빨간 버튼으로 만들 수 있음
            Button(role: .destructive, action: {
                print("삭제하기")
            }, label: {
                Label("삭제하기", systemImage: "exclamationmark.bubble")
            })
        },
        postImage: Image("Community/testImage"),
        myMemo: "오늘은 샐러드를 먹었습니다~ 아보카도를 많이 넣어 먹었어요~~~~~~다들 제 레시피 보고 따라 만들어주시기길......태그도 남겨주시기르를",
        toastVM: ToastViewModel()
    )
}
