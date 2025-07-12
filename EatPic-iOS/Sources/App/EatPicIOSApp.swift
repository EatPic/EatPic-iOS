import SwiftUI

@main
struct EatPicIOSApp: App {
    @StateObject private var container: DIContainer = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container)
        }
    }
}
