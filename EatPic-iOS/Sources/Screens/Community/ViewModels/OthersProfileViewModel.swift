//
//  OthersProfileViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/8/25.
//

import Foundation

@Observable
final class OthersProfileViewModel {
    var user: CommunityUser
    var isFollowed: Bool = true
    var showBlockModal: Bool = false
    var isShowingReportBottomSheet: Bool = false
    
    private var allUsers: [CommunityUser] = sampleUsers
    private var allPicCards: [PicCard] = sampleCards
    
    var picCardCount: Int {
        allPicCards.filter { $0.user.id == user.id }.count
    }
    
    var followerCount: Int {
        // 더미 데이터에는 팔로워 정보가 없으므로 임의의 값 반환
        return 2
    }
    
    var followingCount: Int {
        // 더미 데이터에는 팔로잉 정보가 없으므로 임의의 값 반환
        return 2
    }
    
    var userCards: [PicCard] {
        allPicCards.filter { $0.user.id == user.id }
    }
    
    init(user: CommunityUser) {
        self.user = user
        self.isFollowed = checkFollowStatus(for: user)
    }
    
    func toggleFollow() {
        // TODO: 실제 팔로우/언팔로우 API 호출 로직 구현
        isFollowed.toggle()
        print("\(user.nickname) 팔로우 상태 변경: \(isFollowed)")
    }
    
    func blockUser() {
        // BlockedUsersManager를 통해 차단 처리
        BlockedUsersManager.shared.blockUser(userId: user.id)
        isFollowed = false
        print("\(user.nickname) 차단 완료")
    }
    
    func handleProfileReport(_ reportType: String) {
        print("프로필 신고: \(user.id) - 유형: \(reportType)")
        // TODO: 실제 신고 API 호출 로직 구현
        isShowingReportBottomSheet = false
    }
    
    private func checkFollowStatus(for user: CommunityUser) -> Bool {
        // TODO: 실제 팔로우 상태를 확인하는 로직 구현 (API 호출 등)
        // 현재는 더미 데이터로 임시 구현
        return user.id == "id3" ? true : false
    }
}
