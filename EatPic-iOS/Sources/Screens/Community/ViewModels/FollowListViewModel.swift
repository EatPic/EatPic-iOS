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
                $0.id.localizedCaseInsensitiveContains(searchText)
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

// MARK: - Updated Sample Data (For FollowListView)

let sampleFollowers: [CommunityUser] = [
    CommunityUser(id: "hong", nickname: "홍길동", imageName: nil,
                  isCurrentUser: false, isFollowed: true),
    CommunityUser(id: "young", nickname: "김영희", imageName: nil,
                  isCurrentUser: false, isFollowed: false)
]

let sampleFollowings: [CommunityUser] = [
    CommunityUser(id: "cheolsoo", nickname: "이철수", imageName: nil,
                  isCurrentUser: false, isFollowed: true),
    CommunityUser(id: "minsu", nickname: "박민수", imageName: nil,
                  isCurrentUser: false, isFollowed: true)
]
