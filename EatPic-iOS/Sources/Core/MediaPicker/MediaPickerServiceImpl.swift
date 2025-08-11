//
//  MediaPickerServiceImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/6/25.
//

import PhotosUI

/// `UIImagePickerController`를 사용해 **카메라 촬영**을 제공하는 기본 구현체입니다.
final class MediaPickerServiceImpl: NSObject, MediaPickerService {
    private var multipleImagesCompletion: (([UIImage]) -> Void)?
    private var singleImageCompletion: ((UIImage?) -> Void)?
    
    // MARK: - Helper Methods
    
    /// 최상단에서 보여지는 `UIViewController`를 탐색합니다.
    ///
    /// - Note:
    ///   - 멀티 윈도우 환경 등 복잡한 케이스까지 모두 커버하진 않습니다.
    ///   - 필요 시 `active` 상태의 key window를 우선 탐색하는 방식으로 보강할 수 있습니다.
    private func findTopViewController() -> UIViewController? {
        let scens = UIApplication.shared.connectedScenes
        let windowScens = scens.first as? UIWindowScene
        guard let window = windowScens?.windows.first else { return nil }
        
        var topViewController = window.rootViewController
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    /// 카메라 촬영 UI를 모달로 표시합니다.
    ///
    /// - Parameters:
    ///   - completion: 촬영 결과 콜백. 성공 시 `UIImage`, 취소/실패 시 `nil`.
    ///
    /// - Important:
    ///   - 실제 업로드/표시 전에는 `jpegData(compressionQuality:)` + `downsampledImage`로
    ///     용량/해상도 정책에 맞는 후처리를 적용하세요.
    func presentCamera(
        completion: @escaping (UIImage?) -> Void
    ) {
        guard let viewController = findTopViewController(),
              UIImagePickerController.isSourceTypeAvailable(.camera) else {
            completion(nil)
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        
        self.singleImageCompletion = completion
        viewController.present(picker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MediaPickerServiceImpl: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 사용자가 촬영을 취소한 경우 호출됩니다.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        singleImageCompletion?(nil)
    }
    
    /// 촬영/선택이 완료된 경우 호출됩니다.
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        singleImageCompletion?(info[.originalImage] as? UIImage)
    }
}
