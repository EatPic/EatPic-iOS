//
//  ImageLoadError.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/14/25.
//

import Foundation

enum ImageLoadError: Error, LocalizedError {
    case invalidData
    case decodingFailed
    case networkFailed(Error)
    case fileNotFound

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "이미지 데이터가 유효하지 않습니다."
        case .decodingFailed:
            return "이미지를 불러오는 데 실패했습니다."
        case .networkFailed(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .fileNotFound:
            return "이미지 파일을 찾을 수 없습니다."
        }
    }
}
