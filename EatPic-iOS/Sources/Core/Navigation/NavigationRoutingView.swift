//
//  NavigationRoutingView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/13/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    
    @EnvironmentObject private var container: DIContainer
    private let route: NavigationRoute
    
    init(route: NavigationRoute) {
        self.route = route
    }
    
    var body: some View {
        Group {
            switch route {
            case .calendar:
                Text("Calendar")
            case .notification:
                Text("Notification")
            }
        }
        .environmentObject(container)
    }
}
