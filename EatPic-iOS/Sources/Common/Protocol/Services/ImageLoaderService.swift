//
//  ImageLoaderService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/5/25.
//

import Foundation

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
    func loadImage(from urlString: String?) async
    
    /// 현재 진행 중인 이미지 다운로드 작업을 취소합니다.
    ///
    /// `loadImage(from:)`를 통해 이미지 다운로드가 시작된 이후,
    /// 해당 작업을 중단하고자 할 경우 이 메서드를 호출할 수 있습니다.
    ///
    /// 호출 시 내부적으로 `Kingfisher.DownloadTask.cancel()`이 실행되며,
    /// `currentTask`는 nil로 초기화됩니다.
    func cancel()
}
