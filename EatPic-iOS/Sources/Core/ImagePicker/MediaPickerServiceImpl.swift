//
//  MediaPickerServiceImpl.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/6/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import ImageIO

// MARK: - Transferable (PhotosPicker 연동)

/**
 `PhotosPicker`에서 선택한 이미지 바이트를 **디코딩 시 다운샘플링**하여 `UIImage`로 변환하는 모델입니다.

 - 역할:
   - `PhotosPickerItem.loadTransferable(type:)` 호출 시, 내부 `DataRepresentation`이 실행됩니다.
   - 이 때 Image I/O의 썸네일 기능을 사용해 **작은 해상도로 바로 디코딩**하여 메모리 사용을 줄이고 성능을 높입니다.

 - 설계 포인트:
   - UI 표시용 최대 변 길이는 `MediaPickerConfig.displayMaxDimensions` 상수로 관리합니다.
   - 다운샘플링에 실패하면 throw하여 상위에서 실패 케이스를 처리할 수 있게 합니다.
 */
struct PickedImage: Transferable {
    /// 다운샘플링된 결과 이미지
    let uiImage: UIImage
    
    /// `PhotosPicker`가 전달하는 원시 `Data`를 받아 `UIImage`로 변환하는 전송 규약입니다.
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let img = downsampledImage(
                from: data,
                maxDimension: MediaPickerConfig.displayMaxDimensions
            ) else {
                // 손상 파일, 미지원 포맷, 메모리 부족 등으로 디코딩 실패 시
                throw URLError(.cannotDecodeRawData)
            }
            return PickedImage(uiImage: img)
        }
    }
}

// MARK: - Image I/O Downsampling

/// 주어진 이미지 데이터를 디코딩 시점에서 지정된 최대 크기로 다운샘플링하여 `UIImage`로 반환합니다.
///
/// 이 함수는 Image I/O의 썸네일 생성 기능을 사용하여 원본 이미지를 메모리에 로드하기 전에
/// 축소된 해상도로 디코딩하므로, 메모리 사용량을 절감하고 성능을 향상시킵니다.
/// 특히 고해상도 사진이나 다중 이미지 처리 시 OOM(메모리 부족) 위험을 줄이는 데 효과적입니다.
///
/// - Parameters:
///   - data: 원본 이미지의 바이너리 데이터(`Data`). JPEG, PNG, HEIC 등 다양한 포맷을 지원합니다.
///   - maxDimension: 반환될 이미지의 가장 긴 변의 최대 픽셀 크기. 예를 들어 1200을 지정하면
///     가로 또는 세로 중 더 긴 쪽이 최대 1200px을 넘지 않도록 비율에 맞춰 축소됩니다.
///
/// - Returns: 다운샘플링된 `UIImage` 객체. 디코딩 실패 시 `nil`을 반환합니다.
///
/// - Important:
///   - 디코딩 과정에서 `kCGImageSourceCreateThumbnailWithTransform` 옵션을 사용하여
///     EXIF 방향 정보(회전/미러링)를 픽셀 데이터에 반영하므로, 결과 이미지는 추가 회전 처리 없이
///     바로 올바른 방향으로 표시됩니다.
///   - `kCGImageSourceCreateThumbnailFromImageAlways` 옵션을 사용하여 항상 새로운 썸네일을 생성하므로,
///     원본의 내장 썸네일 품질에 영향을 받지 않습니다.
///   - JPEG 포맷으로 재인코딩 시 알파 채널은 손실됩니다.
///
/// - Complexity:
///   - 시간 복잡도는 디코딩 대상 픽셀 수에 비례합니다.
///     (예: 4000x3000 원본 → maxDimension=1200 → 약 1200x900만 디코딩)
///   - 메모리 사용량은 축소된 해상도 크기에 비례합니다.
///
/// - SeeAlso: [`CGImageSourceCreateThumbnailAtIndex`](https://developer.apple.com/documentation/imageio/1464966-cgimagesourcecreatethumbnailatin)
func downsampledImage(
    from data: Data,
    maxDimension: CGFloat
) -> UIImage? {
    // Swift Data → CFData (Image I/O는 CF 기반 API)
    let cfData = data as CFData
    
    // 지연 파싱 가능한 이미지 소스 생성 (메타만 먼저 확인하고, 실제 디코딩은 썸네일 생성 시)
    guard let src = CGImageSourceCreateWithData(cfData, nil) else {
        return nil
    }
    
    // 썸네일 생성 옵션
    let options: [NSString: Any] = [
        // 내장 썸네일 존재 여부와 무관하게 항상 새로 썸네일 생성
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        // 즉시 디코딩/캐시 (대량 처리 시 메모리 피크를 낮추려면 false 고려)
        kCGImageSourceShouldCacheImmediately: true,
        // EXIF 회전/미러링을 픽셀에 적용
        kCGImageSourceCreateThumbnailWithTransform: true,
        // 긴 변이 maxDimension을 넘지 않도록 축소 디코딩
        kCGImageSourceThumbnailMaxPixelSize: Int(maxDimension)
    ]
    
    // 실제 축소 디코딩 수행
    guard let cgImage = CGImageSourceCreateThumbnailAtIndex(src, 0, options as CFDictionary) else {
        return nil
    }
    
    // UIKit에서 사용하기 쉬운 UIImage로 래핑
    return UIImage(cgImage: cgImage)
}

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

// MARK: - Service Implementation (UIKit Camera)

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

// MARK: - Config

/// 이미지 처리 관련 **정책 상수**를 모아둔 설정 구조체입니다.
///
/// - 변경 이유:
///   - 품질/해상도 정책은 앱 전역에서 일관되게 적용되어야 합니다.
///   - 한 곳에서만 값을 수정해 전체 반영되도록 상수화를 수행합니다.
enum MediaPickerConfig {
    /// UI 표시용(피드/상세 뷰 등) 최대 변 길이
    static let displayMaxDimensions: CGFloat = 1200
    
    /// 업로드 전 JPEG 압축 품질 (0.0 ~ 1.0)
    static let jpegCompressionQuality: CGFloat = 0.9
}

/// 갤러리/카메라 **선택 상태 + 이미지 리스트**를 관리하는 Provider입니다.
///
/// - Responsibilities:
///   1) `PhotosPicker`의 `selections` 바인딩 관리
///   2) 선택 후 **즉시 selections 비우기**로 재진입 시 체크 표시 제거
///   3) 비동기 로딩(다운샘플링 포함) 후 `images`에 반영
///   4) 카메라 촬영 결과를 동일 파이프라인으로 정규화
///
/// - Concurrency:
///   - `@MainActor`로 선언하여 상태 변경이 메인 스레드에서만 일어나도록 보장합니다.
///   - `Task {}` 블록에서 비동기 로딩을 수행하고, 완료 시 메인 액터에서 일괄 반영합니다.
@MainActor
@Observable
final class MediaPickerProvider {
    /// 화면에 표시할 이미지 목록 (다운샘플링 적용됨)
    var images: [UIImage] = []
    
    /// `PhotosPicker`에서 선택된 항목 (임시 상태)
    var selections: [PhotosPickerItem] = []
    
    /// 카메라 촬영 서비스 의존성
    private let mediaPickerService: MediaPickerService
    
    /// - Parameter mediaPickerService: DI를 통한 서비스 주입(테스트/교체 용이)
    init(mediaPickerService: MediaPickerService) {
        self.mediaPickerService = mediaPickerService
    }
    
    /// `PhotosPicker`로 선택된 항목을 로드하고, UI에 반영합니다.
    ///
    /// - Flow:
    ///   1) 현재 `selections`를 스냅샷
    ///   2) `selections.removeAll()`로 **체크 상태 초기화** (다음 재진입 시 이전 체크 표시 방지)
    ///   3) 비동기로 `loadTransferable(type:)` 호출 (내부에서 다운샘플링)
    ///   4) 완료 후 `images`에 추가
    func loadImages() {
        let items = selections
        selections.removeAll() // 재진입 시 체크 표시 초기화
        
        Task {
            var newImages: [UIImage] = []
            for item in items {
                if let picked: PickedImage = try? await item.loadTransferable(type: PickedImage.self) {
                    newImages.append(picked.uiImage)
                }
            }
            images.append(contentsOf: newImages)
        }
    }
    
    /// 카메라 촬영 UI를 표시하고, 결과 이미지를 동일 파이프라인으로 정규화합니다.
    ///
    /// - Note:
    ///   - 촬영 원본은 해상도가 클 수 있으므로, **JPEG 재인코딩 → 다운샘플링**을 거쳐 `images`에 추가합니다.
    func presentCamera() {
        mediaPickerService.presentCamera { [weak self] img in
            guard let self, let img else { return }
            
            // 업로드/표시 정책에 맞게 재인코딩 + 다운샘플링
            let data = img.jpegData(
                compressionQuality: MediaPickerConfig.jpegCompressionQuality
            )
            let downsized = data.flatMap {
                downsampledImage(
                    from: $0,
                    maxDimension: MediaPickerConfig.displayMaxDimensions
                )
            } ?? img
            
            self.images.append(downsized)
        }
    }
    
    /// 인덱스로 이미지 하나를 제거합니다.
    ///
    /// - Parameter index: 제거할 이미지의 인덱스
    func removeImage(at index: Int) {
        guard images.indices.contains(index) else { return }
        images.remove(at: index)
    }
}

// MARK: - Demo View (개발용 미리보기)

/// 간단한 동작 확인을 위한 내부 데모 뷰입니다.
/// - 포함 기능:
///   - `PhotosPicker`로 갤러리에서 이미지 선택
///   - 카메라 촬영
///   - 선택/촬영 이미지의 수평 스크롤 프리뷰 및 개별 삭제
private struct MediaPickerView: View {
    @State private var provider = MediaPickerProvider(
        mediaPickerService: MediaPickerServiceImpl()
    )
    
    var body: some View {
        VStack(spacing: 12) {
            // 갤러리 선택
            PhotosPicker(
                selection: $provider.selections,
                maxSelectionCount: 0,         // 0 = 무제한 선택
                matching: .images
            ) { Text("갤러리에서 선택") }
            .onChange(of: provider.selections) {
                provider.loadImages()
            }
            
            // 카메라 촬영
            Button("카메라로 촬영") {
                provider.presentCamera()
            }
            
            // 간단 프리뷰
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
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
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
