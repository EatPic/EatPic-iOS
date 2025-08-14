//
//  HomeGreetingViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/14/25.
//

import Foundation
import Moya

/// 홈화면 진입시 인사말 데이터 바인딩을 위한 뷰모델
@Observable
class HomeGreetingViewModel {
    private let homeProvider: MoyaProvider<HomeTargetType>
    var greetingResponse: GreetingResponse? // 인사말 응답값
    
    init(container: DIContainer) {
        self.homeProvider = container.apiProviderStore.home()
    }
    
    /// 홈 화면 진입시 환영인사 API 호출(현재 시간에 따라 텍스트가 달라짐)
    func fetchGreetingUser() async {
        do {
            let response = try await homeProvider.requestAsync(.greetingMessage)
            let dto = try JSONDecoder().decode(
                GreetingResponse.self, from: response.data
            )
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
}
