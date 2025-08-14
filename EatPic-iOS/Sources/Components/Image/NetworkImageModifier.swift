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
    
    @State private var reloadSeed: Int = 0
    
    private let maxRetries = 2           // 최초 시도 1회 + 재시도 2회 = 최대 3번
    private let initialBackoff: UInt64 = 300_000_000 // 0.3초 (나노초)
    
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
                VStack {
                    Image(.Network.imgFail)
                        .resizable()
                        .frame(width: 168, height: 170)
                        .aspectRatio(contentMode: .fill)
                    
                    Spacer().frame(height: 37)
                    
                    Text("로딩을 실패했어요")
                        .foregroundStyle(.black)
                        .font(.dsTitle2)
                    
                    Spacer().frame(height: 12)
                    
                    Text("다시 시도해주세요")
                        .foregroundStyle(Color.gray060)
                        .font(.dsSubhead)
                    
                    Button {
                        loader.cancel()
                        reloadSeed &+= 1
                    } label: {
                        Image(.Network.reloadImg)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .aspectRatio(contentMode: .fill)
                    }
                    .padding()
                }
            }
        }
        // url + reloadSeed 조합이 변하면 재실행
        .task(id: taskID) {
            await loadWithBackoff()
        }
        .onDisappear {
            loader.cancel()
        }
        // 원래 content는 시각적으로 숨겨서 "치환" 느낌을 줌
        .background(content.opacity(0))
    }
    
    // 식별자: url이 바뀌거나 reloadSeed가 바뀌면 다시 로드
    private var taskID: String {
        "\(url ?? "nil")#\(reloadSeed)"
    }
    
    @MainActor
    private func loadOnce() async {
        guard let url else {
            state = .failure(NSError(domain: "invalid_url", code: -1))
            return
        }
        state = .loading
        await loader.loadImage(from: url)
        state = loader.state
    }
    
    /// 간단한 지수 백오프 자동 재시도
    private func nextBackoff(for attempt: Int) -> UInt64 {
        // attempt: 0,1,2...
        // 0.3s, 0.6s, 1.2s ...
        initialBackoff << attempt
    }
    
    private func loadWithBackoff() async {
        await loadOnce()
        
        // 성공이면 종료
        if case .success = state { return }
        
        // 자동 재시도 (옵션)
        var attempt = 0
        while attempt < maxRetries, case .failure = state {
            let delay = nextBackoff(for: attempt)
            try? await Task.sleep(nanoseconds: delay)
            await loadOnce()
            attempt += 1
            if case .success = state { break }
        }
    }
}
