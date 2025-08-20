import SwiftUI

@main
struct EatPicIOSApp: App {
    /// 앱 흐름 상태 뷰모델
    @StateObject private var appFlowViewModel: AppFlowViewModel = .init()
    @StateObject private var container: DIContainer = .init()
    @State private var didBootstrap = false
    
    init() {
        GlobalNavigationBarStyle.apply()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
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
            .task {
                // 앱 시작 후 최초 1회만 JWT 존재 여부 체크
                guard !didBootstrap else { return }
                didBootstrap = true
                
                let userSession = container.userSessionKeychain.loadSession(for: .userSession)
                let accessToken = userSession?.accessToken
                let hasValid = accessToken?.isEmpty == false
                
                await MainActor.run {
                    appFlowViewModel.appState = hasValid ? .tab : .login
                }
            }
        }
        .environmentObject(appFlowViewModel)
        .environmentObject(container)
    }
}
