//
//  CreateCardUseCase.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation

/// `CreateCardUseCase`의 기본 구현체입니다.
/// - Note: `UIImage`는 non-Sendable이므로, 인코딩은 `MainActor.run`에서 수행하여 안전성을 확보합니다.
protocol CreateCardUseCase {
    /// 기록 상태와 DTO를 받아 이미지 인코딩 후 서버에 업로드합니다.
    /// - Parameters:
    ///   - state: 화면에서 수집한 기록 상태
    ///   - request: 서버 전송용 DTO
    /// - Returns: 생성된 카드의 식별자
    /// - Throws: `UploadError` 및 레포지토리에서 전달되는 도메인 에러
    func execute(
        state: RecordFlowState,
        request: CreateCardRequest
    ) async throws -> Int
}
