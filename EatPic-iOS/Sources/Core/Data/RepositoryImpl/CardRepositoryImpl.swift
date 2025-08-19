//
//  CardRepositoryImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation
import Moya

/// `CardRepository`의 기본 구현체입니다. Moya를 통해 원격 API와 통신합니다.
/// - Important: 이 계층에서만 DTO/네트워크 세부사항을 다루고, 상위에는 도메인 타입/원시값만 노출합니다.
final class CardRepositoryImpl: CardRepository {
    private let provider: MoyaProvider<CardTargetType>
    private let decoder: JSONDecoder

    init(provider: MoyaProvider<CardTargetType>, decoder: JSONDecoder = JSONDecoder()) {
        self.provider = provider
        self.decoder = decoder
    }

    /// PicCard를 생성합니다(멀티파트 업로드).
    /// - Parameters:
    ///   - request: 전송할 본문 JSON(`CreateCardRequest`)
    ///   - imageData: 업로드할 이미지 바이너리
    ///   - fileName: 파일명(확장자 포함)
    ///   - mimeType: MIME 타입(예: `image/heic`, `image/jpeg`)
    /// - Returns: 생성된 카드의 식별자(`newCardId`)
    /// - Throws: 네트워크/디코딩/서버 오류에 따른 도메인 에러
    func createCard(
        request: CreateCardRequest,
        imageData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> Int {
        let response = try await provider.requestAsync(
            .createFeed(
                request: request,
                image: imageData,
                fileName: fileName,
                mimeType: mimeType
            )
        )
        let envelope = try decoder.decode(APIResponse<CreateCardResult>.self, from: response.data)
        
        guard envelope.isSuccess else {
            throw APIError.serverError(
                code: response.statusCode, message: envelope.message)
        }
        
        return envelope.result.newCardId
    }
}
