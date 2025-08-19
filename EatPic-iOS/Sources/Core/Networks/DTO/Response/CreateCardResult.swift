//
//  CreateCardResult.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation

/// PicCard 생성 결과의 핵심 데이터입니다. 현재는 `newcardId`만 사용합니다.
struct CreateCardResult: Codable {
    let newCardId: Int
    private enum CodingKeys: String, CodingKey {
        case newCardId = "newcardId"
    }
}
