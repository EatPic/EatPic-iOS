//
//  ImageLoaderServiceImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/5/25.
//

import UIKit
import Combine
import Kingfisher

/// 이미지 로딩의 상태를 나타내는 열거형입니다.
///
/// 이 상태는 `ImageLoaderService`가 이미지 로딩 과정을 추적하고,
/// 뷰에서 UI 상태를 동기화할 수 있도록 하기 위해 사용됩니다.
///
/// - idle: 이미지 로딩이 시작되지 않은 초기 상태입니다.
/// - loading: 이미지가 네트워크에서 로딩 중인 상태입니다.
/// - success(UIImage): 이미지 로딩이 성공하여, UIImage 객체를 포함하는 상태입니다.
/// - failure(Error): 이미지 로딩이 실패한 상태이며, 실패 원인을 담은 Error 객체를 포함합니다.
enum ImageLoadState {
    case idle
    case loading
    case success(UIImage)
    case failure(Error)
}

protocol ImageLoaderService {
    var state: ImageLoadState { get }
    
    /// 네트워크를 통해 이미지를 비동기적으로 로드하고, 상태를 업데이트합니다.
    ///
    /// - Parameters:
    ///   - urlString: 로드할 이미지의 URL 문자열입니다. 유효하지 않은 URL인 경우 `state`는 `.failure`로 설정됩니다.
    ///
    /// Kingfisher를 사용하여 이미지 로드를 수행하며, 다음과 같은 옵션이 적용됩니다
    /// - `cacheOriginalImage`: 원본 이미지를 디스크 캐시에 저장하여 재사용 성능을 높입니다.
    /// - `DownsamplingImageProcessor(size: 400x400)`: 메모리 최적화를 위해 이미지를 400x400 크기로 다운샘플링합니다.
    ///   이는 피그마 디자인 기준으로 가장 큰 이미지가 361x361인 점을 반영하여, 적절한 품질을 유지하면서도 성능을 개선하기 위한 설정입니다.
    /// - `scaleFactor`: 디스플레이 스케일에 맞게 이미지를 처리합니다.
    /// - `transition(.fade(0.2))`: 이미지 전환 시 페이드 인 효과를 적용하여 자연스러운 UX를 제공합니다.
    ///
    /// 이미지 로딩 결과는 내부 상태 프로퍼티인 `state`를 통해 `.loading`, `.success(UIImage)`, `.failure(Error)` 형태로 외부에 전달됩니다.
    ///
    /// - Note: 이미지 로딩이 시작되면 기존 다운로드 작업은 취소되지 않으며, 새로운 작업이 `currentTask`에 저장됩니다.
    ///   필요한 경우 `cancel()` 메서드를 통해 취소할 수 있습니다.
    func loadImage(from urlString: String?)
    
    /// 현재 진행 중인 이미지 다운로드 작업을 취소합니다.
    ///
    /// `loadImage(from:)`를 통해 이미지 다운로드가 시작된 이후,
    /// 해당 작업을 중단하고자 할 경우 이 메서드를 호출할 수 있습니다.
    ///
    /// 호출 시 내부적으로 `Kingfisher.DownloadTask.cancel()`이 실행되며,
    /// `currentTask`는 nil로 초기화됩니다.
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
            // 400으로 고정한 이유는, 피그마 디자인상 이보다 더 큰 이미지가 존재하지 않기 때문.
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
