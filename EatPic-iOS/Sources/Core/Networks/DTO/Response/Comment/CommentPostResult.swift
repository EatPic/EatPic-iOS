//
//  CommentPostResult.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/20/25.
//

import Foundation
struct CommentPostResult: Codable {
    let commentId: Int
    let parentCommentID: Int
    let cardId: Int
    let userId: Int
    let content: String
}
