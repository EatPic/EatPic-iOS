//
//  BookmarkResult.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/19/25.
//

import Foundation

// 북마크 저장(post)를 위한 응답 구조체입니다.
struct BookmarkResult: Codable {
    let cardId: Int
    let userId: Int
    let status: String
}
