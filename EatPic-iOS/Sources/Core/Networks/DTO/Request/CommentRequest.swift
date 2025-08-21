//
//  CommentRequest.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/20/25.
//

import Foundation

struct CommentRequest: Codable {
    let parentCommentId: Int?
    let content: String
}
