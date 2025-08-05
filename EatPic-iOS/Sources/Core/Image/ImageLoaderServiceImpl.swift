//
//  ImageLoaderServiceImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/5/25.
//

import UIKit
import Combine
import Kingfisher

enum ImageLoadState {
    case idle
    case loading
    case success(UIImage)
    case failure(Error)
}

protocol ImageLoaderService {
    var state: ImageLoadState { get }
    func loadImage(from urlString: String?)
    func cancel()
}

@Observable
final class ImageLoaderServiceImpl: ImageLoaderService {
    private(set) var state: ImageLoadState = .idle
    private var currentTask: DownloadTask?
    
    func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.state = .failure(URLError(.badURL))
            return
        }
        
        state = .loading
        
        let options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .transition(.fade(0.2)),
            .processor(DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))),
            .scaleFactor(UIScreen.main.scale),
            .cacheSerializer(DefaultCacheSerializer.default)
        ]
        
        currentTask = KingfisherManager.shared
            .retrieveImage(with: url, options: options) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let retrieveResult):
                    self.state = .success(retrieveResult.image)
                case .failure(let error):
                    self.state = .failure(error)
                }
        }
    }
    
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}
