//
//  ImageProcessor.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/10/25.
//

import UIKit
import UniformTypeIdentifiers
import ImageIO

enum ImageProcessor {
    /// 주어진 이미지 데이터를 디코딩 시점에서 지정된 최대 크기로 다운샘플링하여 `UIImage`로 반환합니다.
    ///
    /// 이 함수는 Image I/O의 썸네일 생성 기능을 사용하여 원본 이미지를 메모리에 로드하기 전에
    /// 축소된 해상도로 디코딩하므로, 메모리 사용량을 절감하고 성능을 향상시킵니다.
    /// 특히 고해상도 사진이나 다중 이미지 처리 시 OOM(메모리 부족) 위험을 줄이는 데 효과적입니다.
    ///
    /// - Parameters:
    ///   - data: 원본 이미지의 바이너리 데이터(`Data`). JPEG, PNG, HEIC 등 다양한 포맷을 지원합니다.
    ///   - maxDimension: 반환될 이미지의 가장 긴 변의 최대 픽셀 크기. 예를 들어 1200을 지정하면
    ///     가로 또는 세로 중 더 긴 쪽이 최대 1200px을 넘지 않도록 비율에 맞춰 축소됩니다.
    ///
    /// - Returns: 다운샘플링된 `UIImage` 객체. 디코딩 실패 시 `nil`을 반환합니다.
    ///
    /// - Important:
    ///   - 디코딩 과정에서 `kCGImageSourceCreateThumbnailWithTransform` 옵션을 사용하여
    ///     EXIF 방향 정보(회전/미러링)를 픽셀 데이터에 반영하므로, 결과 이미지는 추가 회전 처리 없이
    ///     바로 올바른 방향으로 표시됩니다.
    ///   - `kCGImageSourceCreateThumbnailFromImageAlways` 옵션을 사용하여 항상 새로운 썸네일을 생성하므로,
    ///     원본의 내장 썸네일 품질에 영향을 받지 않습니다.
    ///   - JPEG 포맷으로 재인코딩 시 알파 채널은 손실됩니다.
    ///
    /// - Complexity:
    ///   - 시간 복잡도는 디코딩 대상 픽셀 수에 비례합니다.
    ///     (예: 4000x3000 원본 → maxDimension=1200 → 약 1200x900만 디코딩)
    ///   - 메모리 사용량은 축소된 해상도 크기에 비례합니다.
    ///
    /// - SeeAlso: [`CGImageSourceCreateThumbnailAtIndex`](https://developer.apple.com/documentation/imageio/1464966-cgimagesourcecreatethumbnailatin)
    static func downsampledImage(
        from data: Data,
        maxDimension: CGFloat
    ) -> UIImage? {
        // Swift Data → CFData (Image I/O는 CF 기반 API)
        let cfData = data as CFData
        
        // 지연 파싱 가능한 이미지 소스 생성 (메타만 먼저 확인하고, 실제 디코딩은 썸네일 생성 시)
        guard let src = CGImageSourceCreateWithData(cfData, nil) else {
            return nil
        }
        
        // 썸네일 생성 옵션
        let options: [NSString: Any] = [
            // 내장 썸네일 존재 여부와 무관하게 항상 새로 썸네일 생성
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            // 즉시 디코딩/캐시 (대량 처리 시 메모리 피크를 낮추려면 false 고려)
            kCGImageSourceShouldCacheImmediately: true,
            // EXIF 회전/미러링을 픽셀에 적용
            kCGImageSourceCreateThumbnailWithTransform: true,
            // 긴 변이 maxDimension을 넘지 않도록 축소 디코딩
            kCGImageSourceThumbnailMaxPixelSize: Int(maxDimension)
        ]
        
        // 실제 축소 디코딩 수행
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(
            src, 0, options as CFDictionary) else {
            return nil
        }
        
        // UIKit에서 사용하기 쉬운 UIImage로 래핑
        return UIImage(cgImage: cgImage)
    }
}
