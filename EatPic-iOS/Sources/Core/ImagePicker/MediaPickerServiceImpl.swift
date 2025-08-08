//
//  ImagePickerService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/6/25.
//

import PhotosUI
import SwiftUI
import UIKit

/// 갤러리 또는 카메라에서 이미지를 가져오는 기능을 추상화한 프로토콜입니다.
protocol MediaPickerService {
    /// 갤러리에서 이미지들을 선택합니다.
    /// - Parameters:
    ///   - allowsMultipleSelection: 다중 선택 허용 여부
    ///   - completion: 선택한 이미지 배열
    func presentPhotoLibrary(
        allowsMultipleSelection: Bool,
        completion: @escaping ([UIImage]) -> Void
    )
    
    /// 카메라를 실행하여 이미지를 촬영합니다.
    func presentCamera(
        completion: @escaping (UIImage?) -> Void
    )
}

final class MediaPickerServiceImpl: NSObject, MediaPickerService {
    private var multipleImagesCompletion: (([UIImage]) -> Void)?
    private var singleImageCompletion: ((UIImage?) -> Void)?
    
    // MARK: - Helper Methods
    
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
    
    func presentPhotoLibrary(
        allowsMultipleSelection: Bool,
        completion: @escaping ([UIImage]) -> Void
    ) {
        guard let viewController = findTopViewController() else {
            completion([])
            return
        }
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = allowsMultipleSelection ? 0 : 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        self.multipleImagesCompletion = completion
        viewController.present(picker, animated: true)
    }
    
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

extension MediaPickerServiceImpl: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        guard !results.isEmpty else {
            multipleImagesCompletion?([])
            return
        }
        
        let providers = results.map(\.itemProvider)
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for provider in providers {
            if provider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                provider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.multipleImagesCompletion?(images)
        }
    }
}

extension MediaPickerServiceImpl: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        singleImageCompletion?(nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        singleImageCompletion?(info[.originalImage] as? UIImage)
    }
}

@Observable
final class MediaPickekProvider {
    var images: [UIImage] = []
    
    private let mediaPickerService: MediaPickerService
    
    init(imagePickerService: MediaPickerService) {
        self.mediaPickerService = imagePickerService
    }
    
    /// View에서 호출되며 이미지 선택 기능 실행
    @MainActor
    func presentPhotoPicker() {
        mediaPickerService.presentPhotoLibrary(
            allowsMultipleSelection: true
        ) { [weak self] newImages in
            self?.images.append(contentsOf: newImages)
        }
    }
    
    @MainActor
    func presentCamera() {
        mediaPickerService.presentCamera { [weak self] newImage in
            guard let newImage = newImage else { return }
            self?.images.append(newImage)
        }
    }
    
    func removeImage(at index: Int) {
        guard images.indices.contains(index) else { return }
        images.remove(at: index)
    }
}
