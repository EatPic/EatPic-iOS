//
//  CommentViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import Foundation
import SwiftUI

@Observable
final class CommentViewModel {
    var commentText: String = ""
    var comments: [Comment] = sampleComments // 예시 댓글 목록
    var isShowingReportBottomSheet: Bool = false
    var commentToReport: Comment? = nil
    
    let toastVM = ToastViewModel()
    
    // 현재 로그인된 사용자의 정보 (임시)
    let dummyFeedUser = FeedUser(
        userId: 98765,
        nameId: "wonjy0307",
        nickname: "원주연",
        profileImageUrl: "https://example.com/images/profile_ju_yeon.jpg"
    )
//    private let currentUser = CommunityUser(
//        id: "itcong", nickname: "잇콩",
//        imageName: "Community/itcong", isCurrentUser: true, isFollowed: true)
    
    func postComment() {
        guard !commentText.isEmpty else { return }
        
        let currentUser = dummyFeedUser.toCommunityUser()
        
        // 새 댓글 생성
        let newComment = Comment(user: currentUser, text: commentText, time: "방금 전")
        
        // 댓글 목록에 추가
        comments.append(newComment)
        // 텍스트 필드 초기화
        commentText = ""
        
        // TODO: - API 통신 로직을 여기에 구현
        print("새 댓글이 추가되었습니다: \(newComment.text)")
        print(comments)
    }
    
    // 댓글 삭제 기능
    func deleteComment(_ comment: Comment) {
        if let index = comments.firstIndex(where: { $0.id == comment.id }) {
            comments.remove(at: index)
            print("댓글이 삭제되었습니다: \(comment.text)")
        }
    }
    
    // contextMenu에서 호출할 댓글 신고 기능
    func reportComment(_ comment: Comment) {
        // 신고할 댓글 정보를 저장하고, 바텀 시트 표시 상태를 true로 변경
        self.commentToReport = comment
        self.isShowingReportBottomSheet = true
        print("댓글 신고: \(comment.text) (ID: \(comment.id))")
        // TODO: - 실제 신고 API 호출 로직 구현
    }
    
    // ReportBottomSheetView에서 선택된 신고 유형을 처리하는 함수
    func handleReport(_ reportType: String) {
        toastVM.showToast(title: "신고되었습니다.")
        if let comment = commentToReport {
            print("댓글 신고: \(comment.text) - 유형: \(reportType)")
        }
        // 신고 처리 후 상태 초기화
        isShowingReportBottomSheet = false
        commentToReport = nil
    }
    
    // 댓글 작성자가 현재 사용자인지 확인하는 메서드
    func isMyComment(_ comment: Comment) -> Bool {
        let currentUser = dummyFeedUser.toCommunityUser()
        return comment.user.id == currentUser.id
    }
    
}
