//
//  PickedImage.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/10/25.
//

import SwiftUI

// MARK: - Transferable (PhotosPicker 연동)

/**
 `PhotosPicker`에서 선택한 이미지 바이트를 **디코딩 시 다운샘플링**하여 `UIImage`로 변환하는 모델입니다.

 - 역할:
   - `PhotosPickerItem.loadTransferable(type:)` 호출 시, 내부 `DataRepresentation`이 실행됩니다.
   - 이 때 Image I/O의 썸네일 기능을 사용해 **작은 해상도로 바로 디코딩**하여 메모리 사용을 줄이고 성능을 높입니다.

 - 설계 포인트:
   - UI 표시용 최대 변 길이는 `MediaPickerConfig.displayMaxDimensions` 상수로 관리합니다.
   - 다운샘플링에 실패하면 throw하여 상위에서 실패 케이스를 처리할 수 있게 합니다.
 */
struct PickedImage: Transferable {
    /// 다운샘플링된 결과 이미지
    let uiImage: UIImage
    
    /// `PhotosPicker`가 전달하는 원시 `Data`를 받아 `UIImage`로 변환하는 전송 규약입니다.
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let img = ImageProcessor.downsampledImage(
                from: data,
                maxDimension: MediaPickerConfig.displayMaxDimensions
            ) else {
                // 손상 파일, 미지원 포맷, 메모리 부족 등으로 디코딩 실패 시
                throw URLError(.cannotDecodeRawData)
            }
            return PickedImage(uiImage: img)
        }
    }
}
