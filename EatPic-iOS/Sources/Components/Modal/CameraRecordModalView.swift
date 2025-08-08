//
//  ModalViewRecord.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/15/25.
//

import SwiftUI

/// 버튼 + 제목 + 설명 + 카메라/사진버튼 + 텍스트로 이루어진 카메라 모달 컴포넌트
///
/// - Parameters:
///   - container: DIContainer 객체 주입
///   - messageTitleColor: 모달 제목 메시지의 색상입니다.
///   - messageDescriptionColor: 모달 설명 메시지의 색상입니다.
///   - buttonColor: 카메라 및 앨범 버튼의 배경 색상입니다.
struct CameraRecordModalView: View {
    @Bindable private var mediaPickekProvider: MediaPickekProvider
    
    /// 모달 제목 메시지 색상
    let messageTitleColor: Color
    
    /// 모달 설명 메시지 색상
    let messageDescriptionColor: Color
    
    /// 카메라/ 앨범 버튼 색상
    let buttonColor: Color
    
    // MARK: - Init
    init(
        container: DIContainer,
        messageTitleColor: Color = .black,
        messageDescriptionColor: Color = .gray060,
        buttonColor: Color = .gray020,
    ) {
        self.messageTitleColor = messageTitleColor
        self.messageDescriptionColor = messageDescriptionColor
        self.buttonColor = buttonColor
        self.mediaPickekProvider = .init(
            imagePickerService: container.mediaPickerService)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            /// 모달 아래 어둡게 처리된 배경
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                // 나가기 x 버튼
                HStack {
                    Spacer()
                    
                    Button(action: {
                        print("모달 나가기 동작")
                    }, label: {
                        Image("Modal/btn_close")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    })
                }
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 8)
                
                /// 모달 제목 메시지
                Text("Pic 카드 기록")
                    .foregroundColor(messageTitleColor)
                    .font(.dsTitle2)
                
                Spacer().frame(height: 8)
               
                /// 모달 설명 메시지
                Text("기록할 방법을 선택해주세요")
                    .foregroundColor(messageDescriptionColor)
                    .font(.dsSubhead)
                
                Spacer().frame(height: 32)

                /// 하단 버튼 두개
                HStack {
                    Spacer()
                    
                    VStack {
                        /// 카메라  버튼
                        Button(action: {
                            mediaPickekProvider.presentCamera()
                        }, label: {
                            
                            ZStack {
                                // 배경 버튼
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(buttonColor)
                                    .frame(width: 70, height: 70)
                                
                                // 버튼 가운데 이미지
                                Image("Modal/ic_record_camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                            }
                        })
                        
                        Spacer().frame(height: 11)
                        
                        /// 카메라 텍스트
                        Text("카메라")
                            .font(.dsBold15)
                    }
                    
                    Spacer().frame(width: 40)
                    
                    VStack {
                        /// 앨범  버튼
                        Button(action: {
                            mediaPickekProvider.presentPhotoPicker()
                        }, label: {
                            
                            ZStack {
                                // 배경 버튼
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(buttonColor)
                                    .frame(width: 70, height: 70)
                                
                                // 버튼 가운데 이미지
                                Image("Modal/ic_record_album")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                            }
                        })
                        
                        Spacer().frame(height: 11)
                        
                        /// 앨범 텍스트
                        Text("사진 앨범")
                            .font(.dsBold15)
                    }
                    
                    Spacer()
                    
                }
            }
            .padding(.top, 18)
            .padding(.bottom, 44)
            .frame(width: 270)
            .background(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    CameraRecordModalView(container: .init())
}
