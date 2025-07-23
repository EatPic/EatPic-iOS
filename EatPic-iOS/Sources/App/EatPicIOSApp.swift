import SwiftUI

@main
struct EatPicIOSApp: App {
    @StateObject private var container: DIContainer = .init()
    
    init() {
        GlobalNavigationBarStyle.apply()
    }
    
    var body: some Scene {
        WindowGroup {
//            MainTabView()
            StoreLocationView(mapView: MapViewAdapter())
                .environmentObject(container)
        }
    }
}
