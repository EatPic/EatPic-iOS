//
//  MyPageMainViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/21/25.
//

import Foundation

@Observable
final class MyPageViewModel {
    private let flow: SignupFlowViewModel

    init(flow: SignupFlowViewModel) {
        self.flow = flow
    }

    // 닉네임/아이디가 비어있을 때 디폴트 처리(원한다면 제거해도 됨)
    var displayNickname: String {
        let nick = flow.model.nickname
        return nick
    }

    var displayIdWithAt: String {
        let id = flow.model.nameId
        return "@\(id)"
    }
}
