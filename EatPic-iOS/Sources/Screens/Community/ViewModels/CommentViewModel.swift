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
    
    // 현재 로그인된 사용자의 정보 (임시)
    private let currentUser = CommunityUser(
        id: "itcong", nickname: "잇콩",
        imageName: "Community/itcong", isCurrentUser: true)

    func postComment() {
        guard !commentText.isEmpty else { return }
        
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
}
