//
//  MultipartField.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation

/// 서버가 기대하는 멀티파트 파트 이름 상수입니다.
/// - Note: Postman 테스트 기준 `cardImageFile`이어야 `cardImageUrl`이 생성됩니다.
enum MultipartField {
    static let cardImage = "cardImageFile"
    static let request = "request"
}
