//
//  FollowListView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/28/25.
//

import SwiftUI

/// 유저 정보를 담는 모델
struct User: Identifiable {
    let id: UUID
    let profileImage: Image?
    let nickname: String
    let userId: String
    var isFollow: Bool
}

/// 팔로워 / 팔로잉 목록을 보여주는 메인 뷰
struct FollowListView: View {
    
    /// 팔로워/팔로잉 탭 구분을 위한 enum
    enum FollowSegment: String, CaseIterable {
        case followers = "팔로워"
        case followings = "팔로잉"
    }
    // MARK: - Properties
    @State private var viewModel: FollowListViewModel
    
    ///어떤 유저의 팔로워/팔로잉을 볼지
    private let userId: Int
    
    @Namespace var name
    
    // MARK: - Init
    init(selected: FollowSegment, container: DIContainer, userId: Int) {
        self.userId = userId
        self._viewModel = State(initialValue: FollowListViewModel(
            selected: selected,
            container: container
        ))
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            segmentedView() // 상단 탭
            
            SearchBarView( // 검색창
                text: $viewModel.searchText,
                placeholder: "닉네임 또는 아이디로 검색",
                showsDeleteButton: false,
                backgroundColor: .gray020,
                strokeColor: nil,
                onSubmit: {
                    Task {
                        await viewModel.fetchFollowList(userId: userId) // 검색 실행
                    }
                },
                onChange: {
                    print("Changed to \($0)")
                }
            )
            .padding(.top, 15)
            .padding(.bottom, 14)
            
            userListView() // 유저 리스트
        }
        .padding(.horizontal, 16)
        .customCenterNavigationBar {
            Text("아이디") // 커스텀 네비게이션바 제목
        }
        // ✅ 화면 진입 시 팔로워/팔로잉 동시에 미리 로드 → 세그먼트 숫자 둘 다 즉시 반영
        .task(id: userId) {
            await viewModel.preloadBoth(userId: userId)
        }
        // ✅ 탭 전환 시 해당 탭만 새로 로드 (검색어 반영 포함)
        .onChange(of: viewModel.selected) {
            Task { await viewModel.fetchFollowList(userId: userId) }
        }
        // (옵션) 당겨서 새로고침: 현재 탭만 갱신
        .refreshable {
            await viewModel.fetchFollowList(userId: userId)
        }
    }
    
    // MARK: - Segment View
    
    /// 팔로워 / 팔로잉 탭을 구성하는 뷰
    private func segmentedView() -> some View {
        HStack(spacing: 0) {
            ForEach(FollowSegment.allCases, id: \.self) { segment in
                Button {
                    viewModel.selected = segment
                } label: {
                    VStack {
                        Text(
                            "\(viewModel.userCount(for: segment)) \(segment.rawValue)"
                        )
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(viewModel.selected == segment ?
                                         Color.gray080 : Color.gray050)
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 4)
                            if viewModel.selected == segment {
                                Capsule()
                                    .fill(Color.gray080)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            } else {
                                Capsule()
                                    .fill(Color.gray040)
                                    .frame(height: 1)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - User List View
    /// 필터링된 유저 리스트를 보여주는 ScrollView
    private func userListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.filteredUsers) { user in
                    userRowView(user: user)
                }
            }
        }
    }
    
    /// 한 명의 유저를 표시하는 행 뷰
    private func userRowView(user: CommunityUser) -> some View {
        HStack(spacing: 16) {
            ProfileImageView(image: user.imageName, size: 47)
            
            VStack(alignment: .leading) {
                Text(user.nickname)
                    .font(.dsSubhead)
                    .foregroundStyle(Color.black)
                Text(user.nameId)
                    .font(.dsSubhead)
                    .foregroundStyle(Color.gray060)
            }
            
            Spacer()
            
            if user.isFollowed {
                PrimaryButton(
                    color: .gray030,
                    text: "팔로잉",
                    font: .dsBold13,
                    textColor: .gray050,
                    width: 64,
                    height: 28,
                    cornerRadius: 5,
                    action: {
                        viewModel.toggleFollow(for: user)
                    }
                )
            } else {
                PrimaryButton(
                    color: .green060,
                    text: "팔로우",
                    font: .dsBold13,
                    textColor: .white,
                    width: 64,
                    height: 28,
                    cornerRadius: 5,
                    action: {
                        viewModel.toggleFollow(for: user)
                    }
                )
            }
        }
    }
}
