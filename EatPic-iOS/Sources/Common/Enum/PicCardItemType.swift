//
//  PicCardItemType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/19/25.
//

import Foundation
import SwiftUI

enum PicCardItemType {
    case bookmark(Bool)
    case comment(Int)
    case reaction(Int, ReactionType?)
    
    var id: String {
        switch self {
        case .bookmark: return "bookmark"
        case .comment: return "comment"
        case .reaction: return "reaction"
        }
    }
    
    @ViewBuilder
    var icon: some View {
        switch self {
        case .bookmark(let isBookmarked):
            Image(isBookmarked ? "icon_bookmark_selected" : "icon_bookmark")
        case .comment:
            Image("icon_comment")
        case .reaction(_, let selected):
            if let emoji = selected?.emoji {
                Text(emoji)
                    .font(.dsHeadline)
            } else {
                Image("icon_emotion")
            }
        }
    }
    
    var count: Int? {
        switch self {
        case .bookmark:
            return nil
        case .comment(let value):
            return value
        case .reaction(let value, _):
            return value
        }
    }
}
