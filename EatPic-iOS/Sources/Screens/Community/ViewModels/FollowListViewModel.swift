//
//  FollowListViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/8/25.
//

import Foundation

@Observable
final class FollowListViewModel {
    
    var selected: FollowListView.FollowSegment
    var searchText: String = ""
    private var followers: [CommunityUser] = sampleFollowers
    private var followings: [CommunityUser] = sampleFollowings
    
    init(selected: FollowListView.FollowSegment) {
        self.selected = selected
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
}

// MARK: - CommunityUser 더미 데이터를 생성하기 위한 FeedUser 더미
let feedUserHong: FeedUser = FeedUser(userId: 101, nameId: "hong", nickname: "홍길동",
                                      profileImageUrl: "https://example.com/images/hong.jpg")
let feedUserYoung: FeedUser = FeedUser(userId: 102, nameId: "young", nickname: "김영희",
                                       profileImageUrl: "https://example.com/images/young.jpg")
let feedUserCheolsoo: FeedUser = FeedUser(userId: 103, nameId: "chul", nickname: "이철수",
                                          profileImageUrl:
                                            "https://example.com/images/cheolsoo.jpg")
let feedUserMinsu: FeedUser = FeedUser(userId: 104, nameId: "minsu", nickname: "박민수",
                                       profileImageUrl: "https://example.com/images/minsu.jpg")


// MARK: - 수정된 CommunityUser 더미 데이터
let sampleFollowers: [CommunityUser] = [
    CommunityUser(from: feedUserHong),
    CommunityUser(from: feedUserYoung)
]

let sampleFollowings: [CommunityUser] = [
    CommunityUser(from: feedUserCheolsoo),
    CommunityUser(from: feedUserMinsu)
]
