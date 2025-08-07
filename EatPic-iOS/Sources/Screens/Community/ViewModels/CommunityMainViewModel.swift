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
    
    // PicCard의 메뉴 액션을 처리하는 함수 (예시)
        func saveCardToPhotos(_ card: PicCard) {
            toastVM.showToast(title: "사진 앱에 저장되었습니다.")
            print("사진 앱에 저장: \(card.id)")
            // TODO: - UIImageWriteToSavedPhotosAlbum 등을 이용한 실제 저장 로직 구현
        }

        func editCard(_ card: PicCard) {
            print("수정하기: \(card.id)")
            // TODO: - 카드 수정 화면으로 이동하는 로직 구현
        }

        func deleteCard(_ card: PicCard) {
            // TODO: - 뱃지 뷰 구현
            print("삭제하기: \(card.id)")
            // TODO: - 카드 삭제 로직 구현
        }

        func reportCard(_ card: PicCard) {
            print("신고하기: \(card.id)")
            // TODO: - 신고 바텀시트 띄우는 로직 구현 (아래에서 수정)
        }

        // PicCard의 작성자가 현재 사용자인지 확인하는 메서드
        func isMyCard(_ card: PicCard) -> Bool {
            // TODO: - 실제 현재 사용자 ID와 비교하는 로직으로 변경
            // 예시: return card.user.id == currentUser.id
            return card.user.id == "나" // 임시 로직
        }
}
