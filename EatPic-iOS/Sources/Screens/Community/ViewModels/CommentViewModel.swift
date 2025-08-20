//
//  CommentViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import Foundation
import Moya
import SwiftUI

@Observable
final class CommentViewModel {
    var commentText: String = ""
    var comments: [Comment] = sampleComments // 예시 댓글 목록
    var isShowingReportBottomSheet: Bool = false
    var commentToReport: Comment? = nil
    var selectedCardId: Int? = nil
    
    let toastVM = ToastViewModel()
    
    private let commentProvider: MoyaProvider<CommentTargetType>
    
    init(container: DIContainer) {
        // APIProviderStore에서 제작한 함수 호출
        self.commentProvider = container.apiProviderStore.comment()
    }
    
    func postComment(parentCommentId: Int = 0) async {
        guard let cardId = selectedCardId else { return }
        guard !commentText.isEmpty else { return }
        
        let request = CommentRequest(
            parentCommentId: cardId,
            content: commentText
        )
        
        do {
            let response = try await commentProvider.requestAsync(
                .postComment(cardId: cardId, request: request)
            )
            
            let dto = try JSONDecoder().decode(
                APIResponse<CommentPostResult>.self,
                from: response.data
            )
            
            // 성공 시 댓글 추가
            let currentUser = dummyFeedUser.toCommunityUser()
            let newComment = Comment(
                user: currentUser,
                text: commentText,
                time: "방금 전"
            )
            
            comments.append(newComment)
            commentText = ""
            
            print("댓글 등록 성공:", dto.result)
            
        } catch {
            print("댓글 등록 실패:", error.localizedDescription)
        }
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
