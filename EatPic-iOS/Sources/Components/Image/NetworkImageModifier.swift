//
//  NetworkImageModifier.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/14/25.
//

import SwiftUI

struct NetworkImageModifier: ViewModifier {
    /// 로딩할 이미지의 URL입니다. `nil`인 경우 로딩 시도는 무시됩니다.
    private let url: String?
    private let contentMode: ContentMode
    
    @State private var state: ImageLoadState = .idle
    
    /// 이미지 로딩을 담당하는 서비스 객체입니다.
    /// 기본적으로 `ImageLoaderServiceImpl()`을 사용하지만, 테스트나 확장을 위해 주입 가능합니다.
    @State private var loader: any ImageLoaderService
    
    /// `NetworkImageView`의 이니셜라이저입니다.
    ///
    /// - Parameters:
    ///   - url: 로드할 이미지의 URL 문자열
    ///   - loader: `ImageLoaderService` 구현체. 기본값은 `ImageLoaderServiceImpl()`
    init(
        url: String?,
        loader: @autoclosure @escaping () -> any ImageLoaderService = ImageLoaderServiceImpl(),
        contentMode: ContentMode = .fill
    ) {
        _loader = .init(initialValue: loader())
        self.url = url
        self.contentMode = contentMode
    }

    func body(content: Content) -> some View {
        ZStack {
            switch state {
            case .idle, .loading:
                ProgressView("로딩 중")
            case .success(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                Text("이미지 로드 실패") // 추후 이미지로 변경 예정
            }
        }
        .task(id: url) {
            guard let url = url else {
                state = .failure(NSError(domain: "invalid_url", code: -1))
                return
            }
            await loader.loadImage(from: url)
            state = loader.state
        }
        .onDisappear {
            loader.cancel()
        }
        // 원래 content는 시각적으로 숨겨서 "치환" 느낌을 줌
        .background(content.opacity(0))
    }
}

extension View {
    /// 현재 View 자리를 네트워크 이미지로 "치환"하듯 그려주는 경량 모디파이어
    func remoteImage(
        url: String?,
        contentMode: ContentMode = .fill
    ) -> some View {
        modifier(
            NetworkImageModifier(
                url: url,
                contentMode: contentMode
            )
        )
    }
}
