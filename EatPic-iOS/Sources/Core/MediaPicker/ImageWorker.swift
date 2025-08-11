//
//  ImageWorker.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/10/25.
//

import UIKit

actor ImageWorker {
    /// 표시용 정규화(예: 1200px, JPEG q=0.9)
    func normalizeForDisplay(_ image: UIImage) -> UIImage {
        let quality = MediaPickerConfig.jpegCompressionQuality
        guard
            let data = image.jpegData(compressionQuality: quality),
            let downsized = ImageProcessor.downsampledImage(
                from: data,
                maxDimension: MediaPickerConfig.displayMaxDimensions
            )
        else { return image }
        return downsized
    }
}
