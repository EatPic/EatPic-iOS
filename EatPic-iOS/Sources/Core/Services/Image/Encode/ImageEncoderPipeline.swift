//
//  ImageEncoderPipeline.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import UIKit

/// 등록된 전략 순서대로 인코딩을 시도하는 파이프라인입니다. 최초 성공 결과를 반환합니다.
struct ImageEncoderPipeline: ImageEncodingStrategy {
    private let strategies: [ImageEncodingStrategy]
    init(_ strategies: [ImageEncodingStrategy]) {
        self.strategies = strategies
    }

    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage? {
        for strategy in strategies {
            if let out = strategy.encode(
                image, maxBytes: maxBytes) { return out }
        }
        return nil
    }
}
