//
//  CommentListResult.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/20/25.
//

import Foundation
// MARK: - 댓글 리스트 결과
struct CommentListResult: Codable {
    let hasNext: Bool
    let nextCursor: Int?
    let commentList: [CommentItem]
}

// MARK: - 개별 댓글
struct CommentItem: Codable, Identifiable {
    let parentCommentId: Int
    let commentId: Int
    let nickname: String
    let nameId: String
    let content: String
    let createdAt: String
    
    var id: Int { commentId } // SwiftUI ForEach 용
}

