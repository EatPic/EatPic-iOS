//
//  PNGEncoder.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import UniformTypeIdentifiers
import ImageIO
import MobileCoreServices
import UIKit

/// PNG 포맷으로 인코딩하는 전략입니다. 무손실이지만 용량이 커질 수 있습니다(최대 바이트 초과 시 실패).
final class PNGEncoder: ImageEncodingStrategy {
    private let filenameBase: String
    init(filenameBase: String = "image") {
        self.filenameBase = filenameBase
    }

    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage? {
        guard let data = image.pngData(),
                data.count <= maxBytes else { return nil }
        return EncodedImage(
            data: data,
            mimeType: "image/png",
            fileExtension: "png",
            fileName: "\(filenameBase).png"
        )
    }
}
