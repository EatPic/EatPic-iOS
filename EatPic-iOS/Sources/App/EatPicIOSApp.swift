import SwiftUI

@main
struct EatPicIOSApp: App {
    @StateObject private var container: DIContainer = .init()
    
    init() {
        GlobalNavigationBarStyle.apply()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView(container: container)
//            LoginView(container: container)
                .environmentObject(container)
        }
    }
}
