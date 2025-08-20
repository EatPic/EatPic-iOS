//
//  ModalViewRecord.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/15/25.
//

import SwiftUI
import PhotosUI

/// 버튼 + 제목 + 설명 + 카메라/사진버튼 + 텍스트로 이루어진 카메라 모달 컴포넌트
///
/// - Parameters:
///   - container: DIContainer 객체 주입
///   - messageTitleColor: 모달 제목 메시지의 색상입니다.
///   - messageDescriptionColor: 모달 설명 메시지의 색상입니다.
///   - buttonColor: 카메라 및 앨범 버튼의 배경 색상입니다.
struct CameraRecordModalView: View {
    @Bindable private var mediaPickerProvider: MediaPickerProvider
    @State private var showCamera = false
    @State private var showPhotosPicker = false

    private let maxImgSelectionCount: Int = 5

    let messageTitleColor: Color
    let messageDescriptionColor: Color
    let buttonColor: Color

    // ⬇️ 추가: 닫기/선택 콜백
    let onClose: () -> Void
    let onPickedImages: ([UIImage]) -> Void

    init(
        container: DIContainer,
        messageTitleColor: Color = .black,
        messageDescriptionColor: Color = .gray060,
        buttonColor: Color = .gray020,
        onClose: @escaping () -> Void,
        onPickedImages: @escaping ([UIImage]) -> Void
    ) {
        self.messageTitleColor = messageTitleColor
        self.messageDescriptionColor = messageDescriptionColor
        self.buttonColor = buttonColor
        self.onClose = onClose
        self.onPickedImages = onPickedImages
        self.mediaPickerProvider = .init(mediaPickerService: container.mediaPickerService)
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button { onClose() } label: {
                    Image("Modal/btn_close").resizable().scaledToFit().frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 16)

            Spacer().frame(height: 8)
            Text("Pic 카드 기록").foregroundColor(messageTitleColor).font(.dsTitle2)
            Spacer().frame(height: 8)
            Text("기록할 방법을 선택해주세요").foregroundColor(messageDescriptionColor).font(.dsSubhead)
            Spacer().frame(height: 32)

            HStack {
                Spacer()

                // 카메라
                VStack {
                    Button { mediaPickerProvider.presentCamera() } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(buttonColor)
                            .frame(width: 70, height: 70)
                            .overlay(Image("Modal/ic_record_camera").resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32))
                    }
                    Spacer().frame(height: 11)
                    Text("카메라").font(.dsBold15)
                }

                Spacer().frame(width: 40)

                // 앨범
                VStack {
                    Button { showPhotosPicker.toggle() } label: {
                        RoundedRectangle(cornerRadius: 10).fill(buttonColor)
                            .frame(width: 70, height: 70)
                            .overlay(Image("Modal/ic_record_album").resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32))
                    }
                    Spacer().frame(height: 11)
                    Text("사진 앨범").font(.dsBold15)
                }

                Spacer()
            }
        }
        .padding(.top, 18)
        .padding(.bottom, 44)
        .frame(width: 270)
        .background(.white)
        .cornerRadius(10)
        .photosPicker(
            isPresented: $showPhotosPicker,
            selection: $mediaPickerProvider.selections,
            maxSelectionCount: maxImgSelectionCount,
            matching: .images
        )
        // 선택 완료/촬영 완료 시 콜백으로 결과 올리기
        .task {
            mediaPickerProvider.onDidAddImages = { images in
                onPickedImages(images)
                onClose()
            }
        }
        .onChange(of: mediaPickerProvider.selections) { _, new in
            mediaPickerProvider.loadImages(from: new)
            mediaPickerProvider.removeAllSelectionsImages()
        }
    }
}
