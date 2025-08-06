//
//  ReportTarget.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/6/25.
//

import Foundation

enum ReportTarget {
    case picCard
    case comment
    
    var subtitle: String {
        switch self {
        case .picCard:
            return "해당 Pic 카드를 신고하는 이유"
        case .comment:
            return "해당 댓글을 신고하는 이유"
        }
    }
}
