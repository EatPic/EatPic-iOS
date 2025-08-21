//
//  OthersProfileView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/24/25.
//

import SwiftUI

/**
 # OthersProfileView
 - 다른 유저의 프로필 화면을 표시합니다.
 - 프로필 사진, 닉네임, 아이디, 소개글, 팔로잉/팔로워/Pic 카드 수 등의 정보를 보여줍니다.
 - 사용자의 피드 이미지를 3열 그리드로 배치합니다.
 - 팔로우/언팔로우 토글 및 차단·신고 기능을 제공합니다.
 
 ## 주요 기능
 - **팔로우/언팔로우**: PrimaryButton을 통해 상태를 전환하며 UI도 즉시 반영됩니다.
 - **신고**: `ReportBottomSheetView`를 통해 프로필 신고 사유 선택 → 신고 처리 → 토스트 노출.
 - **차단**: `DecisionModalView`에서 확인 후 차단 처리 → 토스트 노출 → 2초 뒤 화면 닫기.
 - **팔로워/팔로잉 목록 이동**: 해당 카운트 영역 탭 시 Router를 통해 이동.
 
 ## 상태 관리
 - `@State private var viewModel`: `OthersProfileViewModel`로 사용자 데이터와 상태를 관리.
 - `let toastVM`: 신고 및 차단 후 사용자 피드백 토스트 관리.
 - `@EnvironmentObject private var container`: DIContainer를 통해 Router 및 전역 의존성 접근.
 
 ## UI 구성
 - **프로필 영역** (`userProfileView`):
 - 프로필 이미지, 닉네임, 아이디, 소개글, 팔로워/팔로잉/Pic 카드 수 표시.
 - **팔로우 버튼**:
 - 상태에 따라 색상·텍스트 변경.
 - **피드 영역** (`userFeedView`):
 - 3열 `LazyVGrid`로 이미지 배치.
 - **상단 메뉴**:
 - "차단하기" / "신고하기" 버튼 제공.
 - **모달 & 바텀시트**:
 - 차단: `DecisionModalView`
 - 신고: `ReportBottomSheetView`
 - **토스트**:
 - 신고 또는 차단 후 toastVM을 통해 피드백 표시.
 
 ## 확장 포인트
 - 실제 API 연동으로 팔로우, 차단, 신고 처리.
 - 차단/신고 후 상위 뷰(예: 커뮤니티 메인)와 상태 연동.
 - 사진 탭 시 상세 보기 화면 연결.
 */
struct OthersProfileView: View {
    @State private var viewModel: OthersProfileViewModel
    @EnvironmentObject private var container: DIContainer

    // MARK: - Properties
    let toastVM = ToastViewModel()
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0), spacing: 4),
        GridItem(.flexible(minimum: 0), spacing: 4),
        GridItem(.flexible(minimum: 0), spacing: 4)
    ]
    
    init(user: CommunityUser, container: DIContainer) {
        self._viewModel = State(
            initialValue: OthersProfileViewModel(
                user: user,
                container: container)
        )
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    userProfileView()
                    Spacer().frame(height: 16)
                    
                    if viewModel.isFollowed {
                        PrimaryButton(
                            color: .gray030,
                            text: "팔로잉",
                            font: .dsBold15,
                            textColor: .gray050,
                            width: 109,
                            height: 28,
                            cornerRadius: 6,
                            action: {
                                viewModel.toggleFollow()
                                print("unfollow")
                            })
                    } else {
                        PrimaryButton(
                            color: .green060,
                            text: "팔로우",
                            font: .dsBold15,
                            textColor: .white,
                            width: 109,
                            height: 28,
                            cornerRadius: 6,
                            action: {
                                viewModel.toggleFollow()
                                print("follow")
                            })
                    }
                    Spacer().frame(height: 19)
                    
                    userFeedView()
                }
                .customNavigationBar(title: {
                    Text("")
                }, right: {
                    Menu {
                        Button(role: .destructive) {
                            viewModel.showBlockModal = true
                        } label: {
                            Label("차단하기", systemImage: "hand.raised.slash")
                        }
                        Button(role: .destructive) {
                            viewModel.isShowingReportBottomSheet = true
                        } label: {
                            Label("신고하기", systemImage: "info.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.black)
                    }
                })
            }
            .toastView(viewModel: toastVM)
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .task {
                // 화면 들어올 때(그리고 user.id 바뀔 때) 프로필 + 첫 페이지 로드
                await viewModel.fetchUserProfile()
                await viewModel.fetchUserCards(refresh: true)
            }
            .sheet(isPresented: $viewModel.isShowingReportBottomSheet) {
                ReportBottomSheetView(
                    isShowing: $viewModel.isShowingReportBottomSheet,
                    onReport: { reportType in
                        // 뷰모델의 신고 처리 함수 호출
                        viewModel.handleProfileReport(reportType)
                        toastVM.showToast(title: "신고되었습니다.")
                    },
                    target: .profile // 프로필 신고용으로 지정
                )
                .presentationDetents([.large, .fraction(0.7)])
                .presentationDragIndicator(.hidden)
            }
            
            // showBlockModal 상태에 따라 모달 뷰를 띄움
            if viewModel.showBlockModal {
                DecisionModalView(
                    message: "\(viewModel.user.nickname)(\(viewModel.user.nameId))님을 차단하시겠어요?",
                    messageColor: .gray080,
                    leftBtnText: "취소",
                    rightBtnText: "차단",
                    rightBtnColor: .red050,
                    leftBtnAction: {
                        viewModel.showBlockModal = false // 취소 버튼 탭 시 모달 뷰 닫기
                    },
                    rightBtnAction: {
                        viewModel.blockUser()
                        viewModel.showBlockModal = false
                        toastVM.showToast(title: "차단되었습니다.")
                        // 2초 후에 화면 닫기 (토스트 메시지 사라진 후)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            container.router.pop()
                        }
                    }
                )
            }
        }
    }
    
    // MARK: - View Components
    private func userProfileView() -> some View {
        VStack {
            Spacer().frame(height: 8)
            ProfileImageView(
                image: viewModel.user.imageName,
                size: 100)
            
            Spacer().frame(height: 16)
            
            Text(viewModel.user.nickname)
                .font(.dsTitle3)
                .foregroundStyle(Color.gray080)
            Text("@"+viewModel.user.nameId)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray060)
            Spacer().frame(height: 18)
            
            Text(viewModel.user.introduce ?? "")
                .font(.dsCaption1)
                .foregroundStyle(Color.gray060)
            Spacer().frame(height: 16)
            
            followerCountView()
            Spacer().frame(height: 10)
        }
    }
    
    private func followerCountView() -> some View {
        HStack(spacing: 80) {
            VStack {
                Text("\(viewModel.picCardCount)")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("Pic 카드")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
            
            VStack {
                Text("\(viewModel.followerCount)")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("팔로워")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
            // 팔로워
            .onTapGesture {
                container.router.push(.followList(selected: .followers, userId: viewModel.user.id))
            }
            
            VStack {
                Text("\(viewModel.followingCount)")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("팔로잉")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
            // 팔로잉
            .onTapGesture {
                container.router.push(.followList(selected: .followings, userId: viewModel.user.id))
            }
        }
    }

    private func userFeedView() -> some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width // 좌우 패딩 16씩 제외
            let spacing: CGFloat = 8 // 총 spacing (4 * 2)
            let imageSize = (availableWidth - spacing) / 3 // 3개 컬럼
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(viewModel.feedCards) { card in
                    Rectangle()
                        .remoteImage(url: card.imageUrl)
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipped()
                        .task {
                            await viewModel
                                .loadNextPageIfNeeded(currentCard: card)
                        }
                }
            }
        }
    }
}
