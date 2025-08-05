//
//  NetworkImageView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/5/25.
//

import SwiftUI

struct NetworkImageView: View {
    @State private var loader: any ImageLoaderService
    private let url: String?
    
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
        .onAppear {
            loader.loadImage(from: url)
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
