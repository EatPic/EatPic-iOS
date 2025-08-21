//
//  JPEGEncoder.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import UniformTypeIdentifiers
import ImageIO
import MobileCoreServices
import UIKit

/// JPEG 포맷으로 인코딩하는 전략입니다. 이분 탐색으로 품질을 조정하여 목표 용량을 만족시킵니다.
final class JPEGEncoder: ImageEncodingStrategy {
    private let filenameBase: String
    init(filenameBase: String = "image") {
        self.filenameBase = filenameBase
    }

    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage? {
        // 이분탐색으로 품질 조절
        var low: CGFloat = 0.3, high: CGFloat = 0.9
        var best: Data?
        for _ in 0..<6 {
            let quality = (low + high) / 2
            guard let data = image.jpegData(
                compressionQuality: quality) else { break }
            if data.count > maxBytes {
                high = quality
            } else {
                best = data
                low = quality
            }
        }
        guard let data = best else { return nil }
        return EncodedImage(
            data: data,
            mimeType: "image/jpeg",
            fileExtension: "jpg",
            fileName: "\(filenameBase).jpg"
        )
    }
}
