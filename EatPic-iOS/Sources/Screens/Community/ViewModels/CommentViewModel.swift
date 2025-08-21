//
//  CommentViewModel.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import Foundation
import Moya
import SwiftUI

// MARK: - Lightweight wrapper that decodes only `result` to avoid `code` type mismatch
private struct CommentResponseRoot<T: Decodable>: Decodable {
    let result: T
}

// MARK: - DTOs for current comment API
private struct CommentListDTO: Decodable {
    let hasNext: Bool
    let nextCursor: Int?
    let commentList: [CommentItemDTO]
}

private struct CommentItemDTO: Decodable {
    let parentCommentId: Int?
    let commentId: Int
    let nickname: String
    let nameId: String
    let content: String
    let createdAt: String
}

@MainActor
@Observable
final class CommentViewModel {
    var commentText: String = ""
    var comments: [Comment] = []
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
            print("[CommentVM] fetch: selectedCardId == nil")
            return
        }
        guard !isFetching else {
            print("[CommentVM] fetch: already fetching")
            return
        }
        
        isFetching = true
        
        print("fetchComments 시작 - cardId: \(cardId)")
        defer { isFetching = false }
        
        let cursor = nextCursor
        
        do {
            let response = try await commentProvider.requestAsync(
                .getComment(cardId: cardId, size: 30)
            )
            
            let decoded: CommentResponseRoot<CommentListDTO> = try decodeResponse(response.data)

            let newItems = decoded.result.commentList.map { makeComment(from: $0) }

            if cursor == nil {
                self.comments = newItems
            } else {
                self.comments.append(contentsOf: newItems)
            }
            self.nextCursor = decoded.result.nextCursor
            self.hasNextPage = decoded.result.hasNext
        } catch let error as DecodingError {
            print("[CommentVM] decode error: \(error.shortDescription))")
            toastVM.showToast(title: "댓글을 불러오지 못했습니다.")
        } catch {
            print("[CommentVM] fetch error: \(error.localizedDescription)")
            toastVM.showToast(title: "댓글을 불러오지 못했습니다.")
        }
    }
    
    /// 리스트 하단 근처에서 다음 페이지 로드
    func loadMoreIfNeeded(currentItemID: Int?) async {
        guard let currentItemID, hasNextPage, !isFetching else { return }
        // 마지막 5개 중 하나가 보이면 다음 페이지 요청
        let threshold = 5
        if let index = comments.firstIndex(where: { $0.id == currentItemID }),
           comments.count - index <= threshold {
            await fetchComments()
        }
    }
    
    // 댓글 새로고침 (첫 페이지부터 다시 로드)
    func refreshComments() async {
        comments = []
        nextCursor = nil
        hasNextPage = true
        await fetchComments()
    }
    
    // 시간 문자열 포맷팅 함수
    private func formatTimeString(_ dateString: String) -> String {
        let withFraction = ISO8601DateFormatter()
        withFraction.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds]
        let withoutFraction = ISO8601DateFormatter()
        withoutFraction.formatOptions = [.withInternetDateTime]
        
        let date = withFraction.date(from: dateString) ?? withoutFraction.date(from: dateString)
        
        guard let date else { return "방금 전" }

        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 60 {
            return "방금 전"
        }
        if timeInterval < 3600 {
            return "\(Int(timeInterval / 60))분 전"
        }
        if timeInterval < 86400 {
            return "\(Int(timeInterval / 3600))시간 전"
        }
        
        return "\(Int(timeInterval / 86400))일 전"
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
    
    /// 공통 디코더 헬퍼
    private func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    /// DTO -> Domain 매핑
    private func makeComment(from item: CommentItemDTO) -> Comment {
        Comment(
            id: item.commentId,
            user: CommunityUser(
                id: item.commentId, // 서버에서 userId 미제공 → 임시 식별
                nameId: item.nameId,
                nickname: item.nickname,
                imageName: nil,
                introduce: nil,
                type: .other,
                isCurrentUser: false,
                isFollowed: false
            ),
            text: item.content,
            time: formatTimeString(item.createdAt)
        )
    }
    
}

private extension DecodingError {
    var shortDescription: String {
        func path(_ ctx: DecodingError.Context) -> String {
            ctx.codingPath.map { $0.stringValue }.joined(separator: ".")
        }

        switch self {
        case .typeMismatch(let type, let context):
            return "typeMismatch(\(type)) @ \(path(context))"
        case .valueNotFound(let type, let context):
            return "valueNotFound(\(type)) @ \(path(context))"
        case .keyNotFound(let key, let context):
            let name = key.stringValue
            return "keyNotFound(\(name)) @ \(path(context))"
        case .dataCorrupted(let context):
            return "dataCorrupted @ \(path(context))"
        @unknown default:
            return "unknown"
        }
    }
}
