//
//  CreateCardUseCaseImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation
import UIKit

final class CreateCardUseCaseImpl: CreateCardUseCase {
    private let repository: CardRepository
    private let encoder: ImageEncodingStrategy
    private let maxBytes: Int

    init(
        repository: CardRepository,
        encoder: ImageEncodingStrategy = ImageEncoderPipeline(
            [HEICEncoder(), JPEGEncoder(), PNGEncoder()]),
        maxBytes: Int = 1_000_000,
    ) {
        self.repository = repository
        self.encoder = encoder
        self.maxBytes = maxBytes
    }

    func execute(
        state: RecordFlowState,
        request: CreateCardRequest
    ) async throws -> Int {
        let uiImage: UIImage = try await MainActor.run {
            guard let img = state.images.first else { throw UploadError.missingImage }
            return img
        }
        
        // 파이프라인 인코딩도 메인에서 수행 (UIImage는 non-Sendable)
        let encoded: EncodedImage = try await MainActor.run {
            guard let out = encoder.encode(uiImage, maxBytes: maxBytes) else {
                throw UploadError.encodingFailed
            }
            return out
        }
        
        // Sendable(EncodedImage.data 등)만 다루므로 어느 Actor에서도 안전
        // 추후 여유 생기면, 메인에서 한 번만 UIImage -> Data로 변환하고,
        // 데이터 기반 파이프라인으로 바꿔서 인코딩을 백그라운드로 돌릴 예정
        return try await repository.createCard(
            request: request,
            imageData: encoded.data,
            fileName: encoded.fileName,
            mimeType: encoded.mimeType
        )
    }
}
