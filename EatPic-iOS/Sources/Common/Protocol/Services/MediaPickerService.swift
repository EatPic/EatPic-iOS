//
//  MediaPickerService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/10/25.
//

import UIKit

/**
 카메라 촬영(이미지 캡처)을 담당하는 서비스 프로토콜입니다.

 - 채택 이유:
   - SwiftUI에는 카메라 촬영 컴포넌트가 없기 때문에 UIKit(`UIImagePickerController`)을 사용해야 합니다.
   - 프로토콜로 추상화하여 테스트와 교체(예: 향후 AVCapture 기반 커스텀 카메라) 시 유연성을 확보합니다.
 */
protocol MediaPickerService {
    /// 카메라 촬영 UI를 표시하고 촬영한 이미지를 콜백으로 반환합니다.
    /// 실패/취소 시 `nil`을 반환합니다.
    func presentCamera(completion: @escaping (UIImage?) -> Void)
}
