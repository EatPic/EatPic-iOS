//
//  ModalViewRecord.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/15/25.
//

import SwiftUI

/// 버튼 + 제목 + 설명 + 카메라/사진버튼 + 텍스트로 이루어진 카메라 모달 컴포넌트

/// - Parameters:
///   - xButtonImage: 모달의 우측 상단에 위치하는 닫기(X) 버튼 이미지입니다.
///   - messageTitle: 모달 제목 메시지의 내용을 담습니다
///   - messageTitleColor: 모달 제목 메시지의 색상입니다.
///   - messageDescription: 모달 설명 메시지의 내용을 담습니다
///   - messageDescriptionColor: 모달 설명 메시지의 색상입니다.
///   - cameraButtonImage: 카메라 버튼 이미지입니다.
///   - cameraText: 카메라 버튼 하단에 표시될 텍스트입니다.
///   - albumButtonImage: 사진 앨범 버튼 이미지입니다.
///   - buttonColor: 카메라 및 앨범 버튼의 배경 색상입니다.
///   - albumText: 앨범 버튼 하단에 표시될 텍스트입니다.
struct CameraRecordModalView: View {
    
    // MARK: - Property
    
    /// 나가기 x 버튼 이미지
    let xButtonImage: Image
    
    /// 모달 제목 메시지
    let messageTitle: String
    
    /// 모달 제목 메시지 색상
    let messageTitleColor: Color
    
    /// 모달 설명 메시지
    let messageDescription: String
    
    /// 모달 설명 메시지 색상
    let messageDescriptionColor: Color
    
    /// 카메라 버튼 이미지
    let cameraButtonImage: Image
    
    /// 카메라 버튼 하단 텍스트
    let cameraText: String
    
    /// 앨범 버튼 이미지
    let albumButtonImage: Image
    
    /// 카메라/ 앨범 버튼 색상
    let buttonColor: Color
    
    /// 앨범 버튼 하단 텍스트
    let albumText: String
    
    // MARK: - Init
    init(
        xButtonImage: Image = Image("Modal/btn_close"),
        messageTitle: String = "Pic 카드 기록",
        messageTitleColor: Color = .black,
        messageDescription: String = "기록할 방법을 선택해주세요",
        messageDescriptionColor: Color = .gray060,
        cameraButtonImage: Image = Image("Modal/ic_record_camera"),
        cameraText: String = "카메라",
        albumButtonImage: Image = Image("Modal/ic_record_album"),
        buttonColor: Color = .gray020,
        albumText: String = "사진 앨범"
    ) {
        self.xButtonImage = xButtonImage
        self.messageTitle = messageTitle
        self.messageTitleColor = messageTitleColor
        self.messageDescription = messageDescription
        self.messageDescriptionColor = messageDescriptionColor
        self.cameraButtonImage = cameraButtonImage
        self.cameraText = cameraText
        self.albumButtonImage = albumButtonImage
        self.buttonColor = buttonColor
        self.albumText = albumText
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
                        print("x 나가기")
                    }, label: {
                        xButtonImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    })
                }
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 8)
                
                /// 모달 제목 메시지
                Text(messageTitle)
                    .foregroundColor(messageTitleColor)
                    .font(.dsTitle2)
                
                Spacer().frame(height: 8)
               
                /// 모달 설명 메시지
                Text(messageDescription)
                    .foregroundColor(messageDescriptionColor)
                    .font(.dsSubhead)
                
                Spacer().frame(height: 32)

                /// 하단 버튼 두개
                HStack {
                    Spacer()
                    
                    VStack {
                        /// 카메라  버튼
                        Button(action: {
                            print("카메라")
                        }, label: {
                            
                            ZStack {
                                // 배경 버튼
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(buttonColor)
                                    .frame(width: 70, height: 70)
                                
                                // 버튼 가운데 이미지
                                cameraButtonImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                            }
                        })
                        
                        Spacer().frame(height: 11)
                        
                        /// 카메라 텍스트
                        Text(cameraText)
                        .font(.dsBold15)
                    }
                    
                    Spacer().frame(width: 40)
                    
                    VStack {
                        /// 앨범  버튼
                        Button(action: {
                            print("앨범")
                        }, label: {
                            
                            ZStack {
                                // 배경 버튼
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(buttonColor)
                                    .frame(width: 70, height: 70)

                                // 버튼 가운데 이미지
                                albumButtonImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                            }
                        })
                        
                        Spacer().frame(height: 11)
                        
                        /// 앨범 텍스트
                        Text(albumText)
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
    CameraRecordModalView(
        xButtonImage: Image("Modal/btn_close"),
        messageTitle: "Pic 카드 기록",
        messageDescription: "기록할 방법을 선택해주세요",
        cameraButtonImage: Image("Modal/ic_record_camera"),
        cameraText: "카메라",
        albumButtonImage: Image("Modal/ic_record_album"),
        buttonColor: .gray020,
        albumText: "사진 앨범"
    )
}
