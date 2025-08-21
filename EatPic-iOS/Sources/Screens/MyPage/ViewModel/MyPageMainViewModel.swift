//
//  MyPageMainViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/21/25.
//

import Foundation
import Moya

@Observable
class MyPageMainViewModel {
    
    private let userProvider: MoyaProvider<UserTargetType>
    
    var user: MyUserIconResult?
    
    init(container: DIContainer) {
        self.userProvider = container.apiProviderStore.user()
    }
    
    @MainActor
    func getMyInfo() async {
        do {
            let response = try await userProvider.requestAsync(.getMyUserIcon)
            
            let dto = try JSONDecoder().decode(
                APIResponse<MyUserIconResult>.self,
                from: response.data
            )
            
            self.user = dto.result
            print(dto.result)
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
}
