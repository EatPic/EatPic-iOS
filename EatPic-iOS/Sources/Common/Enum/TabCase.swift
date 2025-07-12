//
//  TabCase.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

enum TabCase: String, CaseIterable {
    case home = "home"
    case community = "community"
    case writePost = "writepost"
    case explore = "explore"
    case myPage = "myPage"
    
    var icon: Image {
        switch self {
        case .home:
            return .init(.Tab.homeUnselected)
        case .community:
            return .init(.Tab.communityUnselected)
        case .writePost:
            return .init(.Tab.add)
        case .explore:
            return .init(.Tab.exploreUnselected)
        case .myPage:
            return .init(.Tab.myPageUnselected)
        }
    }
}
