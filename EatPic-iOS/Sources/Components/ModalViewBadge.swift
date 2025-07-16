//
//  ModalView5.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/15/25.
//

import SwiftUI


/// 버튼 + 뱃지 + 뱃지 제목 + 뱃지 설명 + 해시태그 사용률 버튼 으로 이루어진 모달 컴포넌트

/// - Parameters:
///   - xButtonImage: 모달의 우측 상단에 위치하는 닫기(X) 버튼 이미지입니다.
///   - badge : 뱃지 이미지 입니다 ( 이 부분이 현재 문제)
///   - badgeTitle : 뱃지 이름 입니다
///   - badgeTitleColor: 뱃지 이름 텍스트 색상입니다
///   - badgeDescription: 뱃지 설명 입니다
///   - badgeDescriptionColor: 뱃지 설명 텍스트 색상
///   - buttonColor: 횟수를 보여주는 버튼의 색상입니다
///   - buttonBorderColor : 횟수 버튼의 테두리 색상입니다
///   - buttonTextColor : 횟수 버튼 내부 텍스트 색상입니다.
///   - progressNumText : 해시태그 사용률 ( 0 ~ 10 ) 입니다.
struct ModalViewBadge: View {
    
    // MARK: - Property
    
    /// 모달의 우측 상단에 위치하는 닫기(X) 버튼 이미지
    let xButtonImage: Image
    
    /// 뱃지 이미지
    let badge: Image

    /// 뱃지 이름 텍스트
    let badgeTitle: String

    /// 뱃지 이름 텍스트 색상
    let badgeTitleColor: Color

    /// 뱃지 설명 텍스트
    let badgeDescription: String

    /// 뱃지 설명 텍스트색상
    let badgeDescriptionColor: Color
    
    /// 횟수 버튼 색상
    let buttonColor: Color
    
    /// 횟수 버튼 테두리 색상
    let buttonBorderColor: Color
    
    /// 횟수 버튼 내부 텍스트 색상
    let buttonTextColor: Color
    
    /// 해시태그 사용률 (0 ~ 10)
    let progressNumText: String

    
    
    // MARK: - Init
    init(
        xButtonImage: Image,
        badge: Image,
        badgeTitle: String,
        badgeTitleColor: Color = .black,
        badgeDescription: String,
        badgeDescriptionColor: Color = .gray060,
        buttonColor: Color,
        buttonBorderColor: Color,
        buttonTextColor: Color,
        progressNumText: String
    ) {
        self.xButtonImage = xButtonImage
        self.badge = badge
        self.badgeTitle = badgeTitle
        self.badgeTitleColor = badgeTitleColor
        self.badgeDescription = badgeDescription
        self.badgeDescriptionColor = badgeDescriptionColor
        self.buttonColor = buttonColor
        self.buttonBorderColor = buttonBorderColor
        self.buttonTextColor = buttonTextColor
        self.progressNumText = progressNumText
        
    }
    
    
    // MARK: - Body
    var body: some View {
        ZStack {
            
            /// 모달 아래 어둡게 처리된 배경
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            
            VStack {
                
                // 나가기 x 버튼
                HStack{
                    Spacer()
                
                    Button(action: {
                        
                        // 모달 닫기 동작
                        
                    }) {
                        xButtonImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.horizontal, 15)
                
                
                Spacer().frame(height: 8)

                
                /// Progress Bar
                ZStack{
                    let current = Int(progressNumText) ?? 0 // 현재 기록, 사용 등등.. 의 횟수
                    let denominator = 10 // 10회 고정
                    let progress = CGFloat(current) / CGFloat(denominator)
                    CircleProgressView(
                        progress: progress,
                        size: 130,
                        icon: badge
                    )
                }
                
                Spacer().frame(height: 16)
                
                /// 뱃지 제목 메시지
                Text(badgeTitle)
                    .foregroundColor(badgeTitleColor)
                    .font(.koBold(size: 20))
//                .font(.Title3 20pt)
                
                
                Spacer().frame(height: 8)
                
                
                /// 모달 설명 메시지
                Text(badgeDescription)
                    .padding(.horizontal, 45)
                    .foregroundColor(badgeDescriptionColor)
                    .font(.koRegular(size: 13))
//                .font(.Footnote 13pt)
                    .fixedSize(horizontal: false, vertical: true) // 텍스트의 줄바꿈 허용
                    .multilineTextAlignment(.center) // 텍스트 중앙 정렬
                
                Spacer().frame(height:32)
 
                
                /// 횟수 버튼
                Button(action: {
                    
                    //동작 없는 버튼임!
                    
                }) {
                    Text("\(progressNumText)/10회")
                        .font(.koBold(size: 17))
//                    .font(.Headline 17pt)
                        .foregroundColor(buttonTextColor)
                        .frame(width: 77, height: 34) //버튼 크기
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(buttonBorderColor, lineWidth: 1) // 버튼 테두리
                        )
                }
                .background(buttonColor)
                .cornerRadius(10)
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
            .frame(width: 270)
            .background(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ModalViewBadge(
        xButtonImage: Image("Modal/btn_close"),
        badge: Image(systemName: "star.fill"),
        badgeTitle: "맛집왕",
        badgeTitleColor: .black,
        badgeDescription: "식당 위치가 포함된 Pic카드를 10회 이상 기록 시 획득할 수 있습니다.",
        badgeDescriptionColor: .gray060,
        buttonColor: .green010,
        buttonBorderColor: .green060,
        buttonTextColor: .green050,
        progressNumText: "4"
    )
}

