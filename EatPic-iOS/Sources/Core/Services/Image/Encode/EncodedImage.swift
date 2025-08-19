//
//  EncodedImage.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation

/// 인코딩된 이미지 바이너리와 메타정보를 묶어 전달하기 위한 값 객체입니다.
/// - Note: 멀티파트 업로드 시 `fileName`, `mimeType`을 정확히 지정해야 서버/스토리지 호환성이 보장됩니다.
struct EncodedImage {
    let data: Data
    let mimeType: String
    let fileExtension: String
    let fileName: String
}
