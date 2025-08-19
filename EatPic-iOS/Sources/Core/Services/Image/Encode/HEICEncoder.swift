//
//  HEICEncoder.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import UniformTypeIdentifiers
import ImageIO
import MobileCoreServices
import UIKit

/// HEIC 포맷으로 인코딩하는 전략입니다. 알파 채널이 있을 경우 배경 합성 후 손실 압축을 수행합니다.
/// - Warning: 일부 서버/라이브러리는 `image/heic`를 지원하지 않을 수 있습니다.
final class HEICEncoder: ImageEncodingStrategy {
    private let quality: CGFloat
    private let filenameBase: String

    init(quality: CGFloat = 0.85, filenameBase: String = "image") {
        self.quality = quality
        self.filenameBase = filenameBase
    }

    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage? {
        guard let cgImage = image.cgImage else { return nil }
        guard let utType = UTType.heic.identifier as CFString? else { return nil }

        // 알파가 있는 경우: 필요 시 배경색 합성으로 알파 제거
        let source: CGImage
        if image.hasAlpha, let flattened = image.flattened(background: .white) {
            guard let cgImg = flattened.cgImage else { return nil }
            source = cgImg
        } else {
            source = cgImage
        }

        // 가변 품질로 시도 (간단 이분탐색)
        var low: CGFloat = 0.4
        var high: CGFloat = quality
        var bestData: Data?

        for _ in 0..<6 {
            let quality = (low + high) / 2
            guard let data = Self.encodeHEIC(
                cgImage: source, quality: quality, utType: utType) else { break }
            if data.count > maxBytes {
                high = quality
            } else {
                bestData = data
                low = quality
            }
        }

        guard let final = bestData else { return nil }
        return EncodedImage(
            data: final,
            mimeType: "image/heic",
            fileExtension: "heic",
            fileName: "\(filenameBase).heic"
        )
    }

    private static func encodeHEIC(
        cgImage: CGImage,
        quality: CGFloat,
        utType: CFString
    ) -> Data? {
        let data = NSMutableData()
        guard let dest = CGImageDestinationCreateWithData(
            data, utType, 1, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: quality
        ]
        CGImageDestinationAddImage(dest, cgImage, options as CFDictionary)
        guard CGImageDestinationFinalize(dest) else { return nil }
        return data as Data
    }
}
