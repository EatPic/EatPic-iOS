//
//  FollowListView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/28/25.
//

import SwiftUI

/// 유저 정보를 담는 모델
struct FollowUser: Identifiable {
    let uuid = UUID()
    let id: String
    let nickname: String
    let profileImage: Image?
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
    @Namespace var name
    @State private var selected: FollowSegment
    @State private var searchText = ""
    
    // 샘플 팔로워 유저 리스트
    @State private var followers: [FollowUser] = [
        FollowUser(id: "hong", nickname: "홍길동", profileImage: nil, isFollow: true),
        FollowUser(id: "young", nickname: "김영희", profileImage: nil, isFollow: false)
    ]
    
    // 샘플 팔로잉 유저 리스트
    @State private var followings: [FollowUser] = [
        FollowUser(id: "cheolsoo", nickname: "이철수", profileImage: nil, isFollow: true),
        FollowUser(id: "minsu", nickname: "박민수", profileImage: nil, isFollow: true)
    ]
    
    // 초기 selected 값을 주입받는 init
    init(selected: FollowSegment = .followers) {
        _selected = State(initialValue: selected)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            segmentedView() // 상단 탭
            
            SearchBarView( // 검색창
                text: $searchText,
                placeholder: "닉네임 또는 아이디로 검색",
                showsDeleteButton: false,
                backgroundColor: .gray020,
                strokeColor: nil,
                onSubmit: {
                    print("Submitted")
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
    }
    
    // MARK: - Segment View
    
    /// 팔로워 / 팔로잉 탭을 구성하는 뷰
    private func segmentedView() -> some View {
        HStack(spacing: 0) {
            ForEach(FollowSegment.allCases, id: \.self) { segment in
                Button {
                    selected = segment
                } label: {
                    VStack {
                        Text("\(userCount(for: segment)) \(segment.rawValue)")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(selected == segment ?
                                .gray080 : .gray050)
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 4)
                            if selected == segment {
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
    
    /// 각 탭별 유저 수 계산
    private func userCount(for segment: FollowSegment) -> Int {
        switch segment {
        case .followers:
            return followers.count
        case .followings:
            return followings.count
        }
    }
    
    // MARK: - Filtered User List
    
    /// 검색어에 따라 필터링된 유저 리스트
    private var filteredUsers: [FollowUser] {
        let list = selected == .followers ? followers : followings
        if searchText.isEmpty {
            return list
        } else {
            return list.filter {
                $0.nickname.localizedCaseInsensitiveContains(searchText) ||
                $0.id.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // MARK: - User List View
    
    /// 필터링된 유저 리스트를 보여주는 ScrollView
    private func userListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(filteredUsers) { user in
                    userRowView(user: user)
                }
            }
        }
    }
    
    /// 한 명의 유저를 표시하는 행 뷰
    private func userRowView(user: FollowUser) -> some View {
        HStack(spacing: 16) {
            ProfileImageView(image: user.profileImage, size: 47)
            
            VStack(alignment: .leading) {
                Text(user.nickname)
                    .font(.dsSubhead)
                    .foregroundStyle(Color.black)
                Text("@"+user.id)
                    .font(.dsSubhead)
                    .foregroundStyle(Color.gray060)
            }
            
            Spacer()
            
            if user.isFollow {
                PrimaryButton(
                    color: .gray030,
                    text: "팔로잉",
                    font: .dsBold13,
                    textColor: .gray050,
                    width: 64,
                    height: 28,
                    cornerRadius: 5,
                    action: {
                        toggleFollow(for: user)
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
                        toggleFollow(for: user)
                    }
                )
            }
        }
    }
    
    /// 팔로우 상태 토글 로직
    private func toggleFollow(for user: FollowUser) {
        if selected == .followers {
            if let index = followers.firstIndex(where: { $0.id == user.id }) {
                followers[index].isFollow.toggle()
            }
        } else {
            if let index = followings.firstIndex(where: { $0.id == user.id }) {
                followings[index].isFollow.toggle()
            }
        }
    }
}

#Preview {
    FollowListView()
}
