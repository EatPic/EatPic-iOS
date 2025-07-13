//
//  TabViewContent.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/13/25.
//

import SwiftUI

struct TabViewContent: View {
    
    @EnvironmentObject private var container: DIContainer
    private var tab: TabCase
    
    init(tab: TabCase) {
        self.tab = tab
    }
    
    var body: some View {
        switch tab {
        case .home:
            Button {
                container.router.push(.calendar)
            } label: {
                Text("Home")
            }

        case .community:
            Text("community")
        case .writePost:
            Text("writePost")
        case .explore:
            Text("explore")
        case .myPage:
            Text("myPage")
        }
    }
}
