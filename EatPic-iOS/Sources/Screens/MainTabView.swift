//
//  MainTabView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/12/25.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        NavigationStack(path: $container.router.destinations) {
            Button {
                container.router.push(.explore)
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
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                HStack {
                                    Circle().frame(width: 32, height: 32)
                                    Text("Title")
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    print("오른쪽 버튼")
                                } label: {
                                    Image(systemName: "gearshape")
                                }
                            }
                        }
                case .myPage:
                    Text("myPage")
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DIContainer())
}
