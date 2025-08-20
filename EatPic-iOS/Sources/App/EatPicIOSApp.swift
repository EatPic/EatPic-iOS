import SwiftUI

@main
struct EatPicIOSApp: App {
    /// 앱 흐름 상태 뷰모델
    @StateObject private var appFlowViewModel: AppFlowViewModel = .init()
    @StateObject private var container: DIContainer = .init()
    
    init() {
        GlobalNavigationBarStyle.apply()
    }
    
    var body: some Scene {
        WindowGroup {
            switch appFlowViewModel.appState {
            case .login:
                LoginView(container: container, appFlowViewModel: appFlowViewModel)
            case .tab:
                MainTabView(container: container)
                    .task {
                        container.locationStore.start()
                    }
            }
        }
        .environmentObject(appFlowViewModel)
        .environmentObject(container)
    }
}
