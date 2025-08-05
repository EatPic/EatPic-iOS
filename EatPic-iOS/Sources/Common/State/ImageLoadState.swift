//
//  ImageLoadState.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/5/25.
//

import UIKit

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
