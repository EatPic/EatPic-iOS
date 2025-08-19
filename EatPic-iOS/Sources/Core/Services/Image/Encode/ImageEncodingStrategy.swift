//
//  ImageEncodingStrategy.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import UIKit

/// 이미지 인코딩 전략을 추상화한 프로토콜입니다.
/// - Parameters:
///   - image: 원본 이미지(`UIImage`)
///   - maxBytes: 인코딩 결과가 넘지 말아야 할 최대 바이트
/// - Returns: 조건을 만족하는 `EncodedImage` 또는 실패 시 `nil`
protocol ImageEncodingStrategy {
    // 최대 바이트 제약 하에 인코딩 시도. 실패하면 nil 반환
    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage?
}
