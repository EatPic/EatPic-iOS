//
//  MainTabView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var router: NavigationRouter = .init()
    
    var body: some View {
        NavigationStack(path: $router.destinations) {
            Button {
                router.push(.explore)
            } label: {
                Text("explore")
            }
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .home:
                    Text("home")
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
    }
}

#Preview {
    MainTabView()
}
