//
//  ImagePickerService.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/6/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import ImageIO

struct PickedImage: Transferable {
    let uiImage: UIImage
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let img = downsampledImage(
                from: data,
                maxDimension: MediaPickerConfig.displayMaxDimensions
            ) else {
                throw URLError(.cannotDecodeRawData)
            }
            return PickedImage(uiImage: img)
        }
    }
}

func downsampledImage(
    from data: Data,
    maxDimension: CGFloat
) -> UIImage? {
    let cfData = data as CFData
    guard let src = CGImageSourceCreateWithData(cfData, nil) else {
        return nil
    }
    let options: [NSString: Any] = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: Int(maxDimension)
    ]
    guard let cgImageSourceThumbnailAtIndex = CGImageSourceCreateThumbnailAtIndex(
        src, 0, options as CFDictionary) else { return nil }
    return UIImage(cgImage: cgImageSourceThumbnailAtIndex)
}

protocol MediaPickerService {
    /// 카메라 촬영
    func presentCamera(completion: @escaping (UIImage?) -> Void)
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

/// 이미지 처리 관련 상수를 모아둔 설정 구조체
enum MediaPickerConfig {
    static let displayMaxDimensions: CGFloat = 1200
    
    static let jpegCompressionQuality: CGFloat = 0.9
}

@MainActor
@Observable
final class MediaPickerProvider {
    var images: [UIImage] = []
    var selections: [PhotosPickerItem] = []  // 갤러리 선택 결과
    
    private let mediaPickerService: MediaPickerService
    
    init(mediaPickerService: MediaPickerService) {
        self.mediaPickerService = mediaPickerService
    }
    
    @MainActor
    func loadImages() {
        // 갤러리에서 선택 후 다음 선택 시 체크 표시를 지우기 위한 로직
        let items = selections
        selections.removeAll()

        Task {
            var newImages: [UIImage] = []
            for item in items {
                if let picked: PickedImage = try? await item.loadTransferable(type: PickedImage.self) {
                    newImages.append(picked.uiImage)
                }
            }
            // 메인 액터에서 상태 변경
            images.append(contentsOf: newImages)
        }
    }
    
    @MainActor
    func presentCamera() {
        mediaPickerService.presentCamera { [weak self] img in
            guard let self, let img else { return }
            // 카메라도 크면 재인코딩/다운샘플링
            let data = img.jpegData(
                compressionQuality: MediaPickerConfig.jpegCompressionQuality)
            let downsized = data.flatMap {
                downsampledImage(
                    from: $0,
                    maxDimension: MediaPickerConfig.displayMaxDimensions
                )
            } ?? img
            self.images.append(downsized)
        }
    }
    
    func removeImage(at index: Int) {
        guard images.indices.contains(index) else { return }
        images.remove(at: index)
    }
}

/// MideaPickerProvider Test View
private struct MediaPickerView: View {
    @State private var provider = MediaPickerProvider(
        mediaPickerService: MediaPickerServiceImpl())
    
    var body: some View {
        VStack(spacing: 12) {
            PhotosPicker(
                selection: $provider.selections,
                maxSelectionCount: 0,         // 0 = 무제한
                matching: .images
            ) { Text("갤러리에서 선택") }
            .onChange(of: provider.selections) {
                provider.loadImages()
            }
            
            Button("카메라로 촬영") {
                provider.presentCamera()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(provider.images.enumerated()), id: \.offset) { idx, img in
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    provider.removeImage(at: idx)
                                } label: { Image(systemName: "xmark.circle.fill") }
                            }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MediaPickerView()
}
