//
//  CommunityMainViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import Foundation
import SwiftUI

@Observable
final class CommunityMainViewModel {
    
    // MARK: - View State
    var selectedUser: CommunityUser = sampleUsers[0]
    var isShowingReportBottomSheet = false
    var isShowingCommentBottomSheet = false
    
    let toastVM = ToastViewModel()
    
    // MARK: - Computed Properties
    var filteredCards: [PicCard] {
        if selectedUser.nickname == "전체" {
            return sampleCards
        } else {
            return sampleCards.filter { $0.user == selectedUser }
        }
    }
    
    // MARK: - Actions
    func selectUser(_ user: CommunityUser) {
        self.selectedUser = user
    }
    
    func handleReport(_ reportType: String) {
        print("신고 유형: \(reportType)")
        isShowingReportBottomSheet = false
        toastVM.showToast(title: "신고되었습니다.")
    }
    
    func handleCardAction(_ action: PicCardItemActionType) {
        switch action {
        case .bookmark(let isOn):
            print("북마크 상태: \(isOn)")
        case .comment:
            print("댓글창 열기")
            isShowingCommentBottomSheet = true
        case .reaction(let selected, let counts):
            print("선택된 리액션: \(String(describing: selected)), 리액션 수: \(counts)")
        }
    }
}
