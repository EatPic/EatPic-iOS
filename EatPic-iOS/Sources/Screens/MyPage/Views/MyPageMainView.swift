//
//  MypageMainView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/3/25.
//

import SwiftUI

/// 마이페이지 메인 화면 View
struct MyPageMainView: View {
    @EnvironmentObject private var container: DIContainer
    @State private var viewModel: MyPageMainViewModel
    @State private var allPicCardViewModel: MyAllPicCardViewModel
    @State private var badgeViewModel: MyBadgeStatusViewModel
    
    init(container: DIContainer) {
        self._viewModel = State(initialValue: MyPageMainViewModel(container: container))
        self._allPicCardViewModel = State(initialValue: MyAllPicCardViewModel(container: container))
        self._badgeViewModel = State(initialValue: MyBadgeStatusViewModel(container: container))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Spacer().frame(height: 12)
            topSetupButton
            Spacer()
            middleContents
            bottomContents
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.gray020.ignoresSafeArea())
        .task {
            await viewModel.getMyInfo()
            await allPicCardViewModel.fetchMyCards()
            await badgeViewModel.fetchBadgeList()
        }
    }
    
    // MARK: - TopContentes(상단 콘텐츠)
    
    /// 상단 설정 버튼
    private var topSetupButton: some View {
        HStack(alignment: .top) {
            Spacer()
            Button(
                action: {
                    container.router.push(.settingPage)
                },
                label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                })
            .foregroundStyle(Color.black)
        }
    }
    
    // MARK: - Middle Contents(중앙 콘텐츠)
    
    /// 중앙 컨텐츠 (프로필 이미지, 닉네임 및 아이디, 한줄소개, 팔로워/팔로잉 버튼)
    private var middleContents: some View {
        VStack(alignment: .center, spacing: 16) {
            middleProfileImage
            middleNickname
            middleIntroduction
            middleFollowButton
        }
    }
    
    /// 중앙 프로필 이미지
    private var middleProfileImage: some View {
        Group {
            if let profileImageUrl = viewModel.user?.profileImageUrl, !profileImageUrl.isEmpty {
                AsyncImage(url: URL(string: profileImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image("Community/itcong")
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else {
                Image("Community/itcong")
                    .frame(width: 100, height: 100)
            }
        }
        .padding(.bottom, 16)
    }
    
    /// 마이페이지 프로필 닉네임 및 아이디
    private var middleNickname: some View {
        VStack {
            Text(viewModel.user?.nickname ?? "잇콩")
                .font(.dsTitle3)

            Text(viewModel.user?.nameId ?? "itcong")
                .font(.dsSubhead)
                .foregroundStyle(Color.gray040)
        }
        .multilineTextAlignment(.center)
    }

    /// 마이페이지 프로필 사용자 한줄소개 텍스트
    private var middleIntroduction: some View {
        VStack {
            Text(viewModel.user?.introduce ?? "안녕하세요 밥 먹는거 좋아하는 잇콩입니다\n밥을 정말 좋아합니다.")
        }
        .font(.dsCaption1)
        .multilineTextAlignment(.center)
    }
    
    /// 마이페이지 팔로워 및 팔로잉 버튼
    private var middleFollowButton: some View {
        HStack {
            Spacer()
            
            Button {
                guard let uid = viewModel.user?.userId else { return } // 유저 아이디 생성
                container.router.push(.followList(selected: .followers, userId: uid))
            } label: {
                VStack(spacing: 2) {
                    Text("0")
                        .font(.dsTitle3)
                    Text("팔로워")
                        .font(.dsCaption1)
                }
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)
            }

            Spacer()
            
            Button {
                /// 팔로잉 버튼 네비게이션
                guard let uid = viewModel.user?.userId else { return } // 유저 아이디 생성
                container.router.push(.followList(selected: .followings, userId: uid))
            } label: {
                VStack(spacing: 2) {
                    Text("0")
                        .font(.dsTitle3)
                    Text("팔로잉")
                        .font(.dsCaption1)
                }
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)
            }

            Spacer()
        }
    }
    
    // MARK: - Bottom Contents
    
    /// 바텀 카드뷰 공용컴포넌트 호출
    private var bottomContents: some View {
        VStack(spacing: 16) {
            MyPageCardView(
                iconName: "card",
                title: "전체 Pic 카드",
                description: "나의 전체 Pic 카드 확인해보기",
                countText: "\(allPicCardViewModel.feedCards.count)개"
            ) {
                print("전체 카드 클릭")
                container.router.push(.myAllPicCard)
            }

            MyPageCardView(
                iconName: "bookmark",
                title: "저장한 Pic 카드",
                description: "내가 저장한 Pic 카드 확인해보기",
                countText: "\(allPicCardViewModel.feedCards.count)개"
            ) {
                print("저장 카드 클릭")
                container.router.push(.savedPicCard)
            }

            MyPageCardView(
                iconName: "badge",
                title: "활동 배지",
                description: "지금까지 모은 뱃지 확인해보기",
                countText: "\(badgeViewModel.getBadgeStatus())개"
            ) {
                print("배지 클릭")
                container.router.push(.myBadgeStatusAll)
            }
        }
    }
}

#Preview {
    MyPageMainView(container: .init())
}
