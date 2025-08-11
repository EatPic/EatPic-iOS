import SwiftUI

@main
struct EatPicIOSApp: App {
    @StateObject private var container: DIContainer = .init()
    
    init() {
        GlobalNavigationBarStyle.apply()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView(container: container)
                .environmentObject(container)
        }
    }
}
