import SwiftUI

@main
struct EatPicIOSApp: App {
    /// 앱 흐름 상태 뷰모델
    @StateObject private var appFlowViewModel: AppFlowViewModel = .init()
    @StateObject private var container: DIContainer = .init()
    @State private var didBootstrap = false
    
    @Environment(\.scenePhase) private var scenePhase
    
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
                        .task(id: appFlowViewModel.appState) {
                            guard appFlowViewModel.appState == .tab else {
                                return
                            }
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
            // 전역 포그라운드 복귀 훅(선택): 탭 상태일 때만 전파
            .onChange(of: scenePhase) { _, phase in
                guard phase == .active,
                      appFlowViewModel.appState == .tab else { return }
                // 어떤 탭이 선택되어 있는지는 MainTabView가 판단해서 bump 하는 형태로도 충분합니다.
                // 전역에서 일괄로 한 번 더 bump 하려면 아래를 사용하세요. (중복이 우려되면 생략)
                // container.bumpForegroundRefresh()
            }
        }
        .environmentObject(appFlowViewModel)
        .environmentObject(container)
    }
}
