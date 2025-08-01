//
//  RecomPicCardModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

// 홈 뷰의 추천 픽카드 모델
struct RecomPicCardModel: Identifiable {
    let id: String = UUID().uuidString
    let imageName: String
}
