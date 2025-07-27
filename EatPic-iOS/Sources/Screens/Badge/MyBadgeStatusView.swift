//
//  MyBadgeStatusView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

public struct MyBadgeStatusView: View {
    public var body: some View {
        // 추후 잇콩님은 SignUp? Login? 의 AppStorage에 저장된걸 가져와야하나?? 어떻게 해놓지 이거를
        
        VStack {
            Spacer().frame(height: 32)
            
            Text("잇콩님이 획득한 뱃지 현황")
        }
        .customNavigationBar {
            Text("활동 뱃지")
        } right: {
            EmptyView()
        }
    }
}


#Preview {
    MyBadgeStatusView()
}
