//
//  MediaPickerProvider.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/10/25.
//

import SwiftUI
import PhotosUI

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
    
    private let worker = ImageWorker() // 백그라운드 actor
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
        
        Task { // 메인에서 시작하지만 내부 await로 백그라운드 hop
            var buffer: [UIImage] = []
            for item in items {
                if let picked: PickedImage = try? await item.loadTransferable(
                    type: PickedImage.self) {
                    buffer.append(picked.uiImage)
                }
            }
            // 불변 스냅샷으로 캡처
            let snapshot = buffer
            images.append(contentsOf: snapshot) // 메인 액터에서 안전
        }
    }
    
    /// 카메라 촬영 UI를 표시하고, 결과 이미지를 동일 파이프라인으로 정규화합니다.
    ///
    /// - Note:
    ///   - 촬영 원본은 해상도가 클 수 있으므로, **JPEG 재인코딩 → 다운샘플링**을 거쳐 `images`에 추가합니다.
    func presentCamera() {
        mediaPickerService.presentCamera { [weak self] img in
            guard let self, let img else { return }
            
            Task {
                let processed = await self.worker.normalizeForDisplay(img)
                self.images.append(processed) // 메인 액터에서 처리됨
            }
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
private struct MediaPickerTestView: View {
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
    MediaPickerTestView()
}
