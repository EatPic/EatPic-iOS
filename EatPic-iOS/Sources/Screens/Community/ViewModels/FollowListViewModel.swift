//
//  FollowListViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/8/25.
//

import Foundation
import Moya

// MARK: - DTO

// /api/search/followList 결과
struct FollowListResult: Codable {
    let accounts: [FollowAccountDTO]
    let nextCursor: Int?   // 서버가 int64지만 iOS Int(64-bit)로 충분
    let size: Int
    let hasNext: Bool
}

// 개별 계정 항목
struct FollowAccountDTO: Codable {
    let userId: Int
    let nameId: String
    let nickname: String
    let profileImageUrl: String?
    let isFollowed: Bool
    let followed: Bool

    var id: Int { userId }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nameId = "name_id"
        case nickname
        case profileImageUrl = "profile_image_url"
        case isFollowed
        case followed
    }
}

@Observable
final class FollowListViewModel {
    
    /// Providers
    var userProvider: MoyaProvider<UserTargetType>
    
    var selected: FollowListView.FollowSegment
    var searchText: String = ""
   
    // 서버에서 불러온 값 저장
    private var followers: [CommunityUser] = []
    private var followings: [CommunityUser] = []
        
    init(selected: FollowListView.FollowSegment, container: DIContainer) {
        self.selected = selected
        self.userProvider = container.apiProviderStore.user()
    }
    
    var filteredUsers: [CommunityUser] {
        let list = selected == .followers ? followers : followings
        if searchText.isEmpty {
            return list
        } else {
            return list.filter {
                $0.nickname.localizedCaseInsensitiveContains(searchText) ||
                $0.nameId.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func userCount(for segment: FollowListView.FollowSegment) -> Int {
        switch segment {
        case .followers:
            return followers.count
        case .followings:
            return followings.count
        }
    }
    
    func toggleFollow(for user: CommunityUser) {
        if selected == .followers {
            if let index = followers.firstIndex(where: { $0.id == user.id }) {
                // 모델의 isFollowed 속성을 직접 토글합니다.
                followers[index].isFollowed.toggle()
            }
        } else {
            if let index = followings.firstIndex(where: { $0.id == user.id }) {
                // 모델의 isFollowed 속성을 직접 토글합니다.
                followings[index].isFollowed.toggle()
            }
        }
    }
    
    // MARK: - API Methods
    /// 팔로우 목록 리스트 불러오기
    @MainActor
    func fetchFollowList(
        userId: Int,
        cursor: Int? = nil,
        limit: Int = 10,
        override statusOverride: FollowStatus? = nil
    ) async {
        do {
            let status: FollowStatus = statusOverride ?? ((selected == .followers)
                                                          ? .followed : .following)
            let response = try await userProvider.requestAsync(
                .getUserFollowList(
                    status: status,
                    userId: userId,
                    query: searchText,
                    limit: limit,
                    cursor: cursor)
            )
            let decoded = try JSONDecoder().decode(APIResponse<FollowListResult>.self,
                                                   from: response.data)
            
            let users = decoded.result.accounts.map { dto in
                CommunityUser(
                    id: dto.userId,
                    nameId: dto.nameId,
                    nickname: dto.nickname,
                    imageName: dto.profileImageUrl,
                    introduce: nil,
                    isFollowed: dto.isFollowed
                )
            }

            if status == .followed {
                self.followers = users
            } else {
                self.followings = users
            }
            
        } catch {
            print("팔로워/팔로잉 불러오기 실패:", error)
        }
    }
    
    /// 초기 진입 시 팔로워 숫자와 팔로잉 숫자 둘 다 선로드
    @MainActor
    func preloadBoth(userId: Int) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.fetchFollowList(userId: userId, override: .followed)
            }   // 팔로워 숫자 조회
            group.addTask {
                await self.fetchFollowList(userId: userId, override: .following)
            } // 팔로잉 숫자 조회
        }
    }
}
