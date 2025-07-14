//
//  TabCase.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

enum TabCase: String, CaseIterable {
    case home = "홈"
    case community = "커뮤니티"
    case writePost = "글쓰기"
    case explore = "탐색"
    case myPage = "마이페이지"
    
    var icon: Image {
        switch self {
        case .home:
            return .init(.Tab.home)
        case .community:
            return .init(.Tab.community)
        case .writePost:
            return .init(.Tab.add)
        case .explore:
            return .init(.Tab.explore)
        case .myPage:
            return .init(.Tab.myPage)
        }
    }
}
