//
//  NetworkImageView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/5/25.
//

import SwiftUI

/// 네트워크 상의 이미지를 비동기적으로 로드하여 화면에 표시하는 뷰입니다.
///
/// 내부적으로 `ImageLoaderService`를 통해 이미지를 가져오며,
/// 이미지 상태에 따라 `ProgressView`, 성공 이미지, 실패 텍스트를 자동으로 렌더링합니다.
///
/// ```swift
/// NetworkImageView(url: "https://example.com/image.jpg")
/// ```
///
/// - Note: 이미지 로드 상태가 `.loading`, `.success`, `.failure`에 따라 다른 뷰를 보여줍니다.
struct NetworkImageView: View {
    
    /// 이미지 로딩을 담당하는 서비스 객체입니다.
    /// 기본적으로 `ImageLoaderServiceImpl()`을 사용하지만, 테스트나 확장을 위해 주입 가능합니다.
    @State private var loader: any ImageLoaderService
    
    /// 로딩할 이미지의 URL입니다. `nil`인 경우 로딩 시도는 무시됩니다.
    private let url: String?
    
    /// `NetworkImageView`의 이니셜라이저입니다.
    ///
    /// - Parameters:
    ///   - url: 로드할 이미지의 URL 문자열
    ///   - loader: `ImageLoaderService` 구현체. 기본값은 `ImageLoaderServiceImpl()`
    init(
        url: String?,
        loader: @autoclosure @escaping () -> any ImageLoaderService = ImageLoaderServiceImpl()
    ) {
        _loader = .init(initialValue: loader())
        self.url = url
    }
    
    var body: some View {
        Group {
            switch loader.state {
            case .idle, .loading:
                ProgressView("로딩 중")
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Text("이미지 로드 실패")
            }
        }
        .task {
            await loader.loadImage(from: url)
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
