//
//  ImageLoaderServiceImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/5/25.
//

import UIKit
import Combine
import Kingfisher

@Observable
final class ImageLoaderServiceImpl: ImageLoaderService {
    private(set) var state: ImageLoadState = .idle
    private var currentTask: DownloadTask?
    
    func loadImage(from urlString: String?) async {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.state = .failure(URLError(.badURL))
            return
        }
        
        state = .loading
        
        let options: KingfisherOptionsInfo = await [
            .cacheOriginalImage,
            .transition(.fade(0.2)),
            // 400으로 고정한 이유는, 피그마 디자인상 이보다 더 큰 이미지가 존재하지 않기 때문.
            .processor(DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))),
            .scaleFactor(UIScreen.main.scale),
            .cacheSerializer(DefaultCacheSerializer.default)
        ]
        
        do {
            let image = try await retrieveImageAsync(with: url, options: options)
            self.state = .success(image)
        } catch {
            self.state = .failure(error)
        }
        
    }
    
    /// `KingfisherManager`의 클로저 기반 `retrieveImage`를 async/await 방식으로 래핑합니다.
    private func retrieveImageAsync(
        with url: URL,
        options: KingfisherOptionsInfo
    ) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            currentTask = KingfisherManager.shared.retrieveImage(
                with: url,
                options: options,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        continuation.resume(returning: value.image)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            )
        }
    }
    
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}
