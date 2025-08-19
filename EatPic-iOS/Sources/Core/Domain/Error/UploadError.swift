//
//  UploadError.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation

/// 업로드 과정에서 발생할 수 있는 도메인 에러입니다. 사용자 메시지로 변환하기 쉽도록 `LocalizedError`를 채택합니다.
enum UploadError: LocalizedError {
    /// 업로드할 이미지가 없는 경우
    case missingImage
    /// 인코딩(압축/변환)에 실패한 경우
    case encodingFailed
    /// 서버 응답이 비정상일 때
    case invalidServerResponse
    /// 네트워크 오류
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .missingImage:
            return "업로드할 이미지가 없습니다."
        case .encodingFailed:
            return "이미지를 인코딩하는 데 실패했습니다."
        case .invalidServerResponse:
            return "서버 응답이 올바르지 않습니다."
        case .networkError(let error):
            return "네트워크 오류가 발생했습니다: \(error.localizedDescription)"
        }
    }
}
