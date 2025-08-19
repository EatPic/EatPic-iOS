//
//  CardRepository.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import Foundation

/// PicCard 생성/조회 등 카드 관련 데이터를 다루는 도메인 리포지토리 인터페이스입니다.
/// - Note: 도메인 계층의 추상화로서, Moya/URLSession 등의 세부 구현을 알지 못합니다.
protocol CardRepository {
    func createCard(
        request: CreateCardRequest,
        imageData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> Int
}
