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
    var comments: [Comment] = sampleComments
    var isShowingReportBottomSheet: Bool = false
    var commentToReport: Comment? = nil
    var selectedCardId: Int? = nil
    
    // 페이징 관련 프로퍼티 추가
    private var nextCursor: Int? = nil
    private var hasNextPage: Bool = true
    private var isFetching: Bool = false
    
    let toastVM = ToastViewModel()
    
    private let commentProvider: MoyaProvider<CommentTargetType>
    
    init(container: DIContainer) {
        // APIProviderStore에서 제작한 함수 호출
        self.commentProvider = container.apiProviderStore.comment()
    }
    
    func postComment() async {
        guard let cardId = selectedCardId else { return }
        guard !commentText.isEmpty else { return }
        
        let request = CommentRequest(
            parentCommentId: nil,
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
            
            // 댓글 등록 성공 시 목록 새로고침
            commentText = ""
            await refreshComments()
            
            print("댓글 등록 성공:", dto.result)
            
        } catch {
            print("댓글 등록 실패:", error.localizedDescription)
            toastVM.showToast(title: "댓글 등록에 실패했습니다.")
        }
    }
    
    func fetchComments() async {
        guard let cardId = selectedCardId else {
                print("fetchComments 실패: selectedCardId가 nil")
                return
            }
            guard !isFetching else {
                print("fetchComments 실패: 이미 fetching 중")
                return
            }
            
            print("fetchComments 시작 - cardId: \(cardId)")
            isFetching = true
        
        let cursor = nextCursor
        
        do {
            let response = try await commentProvider.requestAsync(
                .getComment(cardId: cardId, size: 30)
            )
            let dto = try JSONDecoder()
                .decode(APIResponse<CommentListResult>.self, from: response.data
            )
            // CommentItem을 Comment로 변환
            let newComments = dto.result.cardFeedList.map { commentItem in
                Comment(
                    id: commentItem.cardFeedId,
                    user: CommunityUser(
                        id: commentItem.user.userId,
                        nameId: commentItem.user.nameId,
                        nickname: commentItem.user.nickname,
                        imageName: nil, // 기본 이미지 사용
                        introduce: nil,
                        type: .other,
                        isCurrentUser: false,
                        isFollowed: false
                    ),
                    text: commentItem.content,
                    time: formatTimeString(commentItem.createdAt)
                )
            }
            
            DispatchQueue.main.async {
                if cursor == 0 {
                    // 첫 번째 로드인 경우 기존 댓글 대체
                    self.comments = newComments
                } else {
                    // 추가 로드인 경우 댓글 추가
                    self.comments.append(contentsOf: newComments)
                }
                
                self.nextCursor = dto.result.nextCursor
                self.hasNextPage = dto.result.hasNext
                self.isFetching = false
            }
            
            print("댓글 불러오기 성공 - 카드 ID: \(cardId), 댓글 수: \(newComments.count)")
            
        } catch {
            print("댓글 불러오기 실패:", error.localizedDescription)
        }
    }
    
    // 댓글 새로고침 (첫 페이지부터 다시 로드)
    func refreshComments() async {
        nextCursor = nil
        hasNextPage = true
        await fetchComments()
    }
    
    // 시간 문자열 포맷팅 함수
    private func formatTimeString(_ dateString: String) -> String {
        // createdAt 문자열을 "몇 분 전", "몇 시간 전" 등으로 변환
        // 실제 구현은 프로젝트의 시간 포맷팅 규칙에 따라 조정
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: dateString) else {
            return "방금 전"
        }
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 60 {
            return "방금 전"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)분 전"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)시간 전"
        } else {
            let days = Int(timeInterval / 86400)
            return "\(days)일 전"
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
