//
//  ModalViewBadge.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/15/25.
//
import SwiftUI

/// 뱃지 상태 ( badgeUnlocked : 뱃지 획득 중 ~ 획득 완료) , badgeLocked ( 뱃지 획득 이전)
enum BadgeState {
    // 뱃지 획득 중 ~ 획득 완료 상태
    case badgeUnlocked(progress: CGFloat, icon: Image)
    // 뱃지 잠금 상태
    case badgeLocked
}

extension BadgeState {
    // 뱃지 획득 상태에 따라 불러오는 버튼 색상
    var buttonColor: Color {
        switch self {
        case .badgeUnlocked: return .green010
        case .badgeLocked: return .gray030
        }
    }
    
    // 뱃지 획득 상태에 따라 불러오는 버튼 테두리 색상
    var buttonBorderColor: Color {
        switch self {
        case .badgeUnlocked: return .green060
        case .badgeLocked: return .gray060
        }
    }
    
    // 뱃지 획득 상태에 따라 불러오는 버튼 텍스트 색상
    var buttonTextColor: Color {
        switch self {
        case .badgeUnlocked: return .green050
        case .badgeLocked: return .gray060
        }
    }
    
    // 뱃지 획득 상태에 따라 불러오는 버튼 색상
    var progressNumText: String {
        switch self {
        case .badgeUnlocked(let progress, _): // 첫번째 연관값 progress만 꺼내고, 두번째 값 icon은 꺼내지 않음(_)
            let value = Int(progress * 10)
            return "\(value)"
        case .badgeLocked:
            return "0"
        }
    }
}

/// 버튼 + 뱃지 + 뱃지 제목 + 뱃지 설명 + 해시태그 사용률 버튼 으로 이루어진 모달 컴포넌트
/// - Parameters:
///   - state: 현재 뱃지 상태로 progress : 뱃지 획득 중 ~ 획득 완료) , locked ( 뱃지 획득 이전) 중 하나입니다
///   - xButtonImage: 모달의 우측 상단에 위치하는 닫기(X) 버튼 이미지입니다.
///   - badgeTitle : 뱃지 이름 입니다
///   - badgeTitleColor: 뱃지 이름 텍스트 색상입니다
///   - badgeDescription: 뱃지 설명 입니다
///   - badgeDescriptionColor: 뱃지 설명 텍스트 색상
///   - buttonColor: 횟수를 보여주는 버튼의 색상입니다
///   - buttonBorderColor : 횟수 버튼의 테두리 색상입니다
///   - buttonTextColor : 횟수 버튼 내부 텍스트 색상입니다.
struct ModalViewBadge: View {
    
    // MARK: - Property
    
    // 뱃지 상태
    let state: BadgeState
    
    /// 모달의 우측 상단에 위치하는 닫기(X) 버튼 이미지
    let xButtonImage: Image
    
    /// 뱃지 크기
    let badgeSize: CGFloat
    
    /// 뱃지 이름 텍스트
    let badgeTitle: String
    
    /// 뱃지 이름 텍스트 색상
    let badgeTitleColor: Color
    
    /// 뱃지 설명 텍스트
    let badgeDescription: String
    
    /// 뱃지 설명 텍스트색상
    let badgeDescriptionColor: Color
    
    // MARK: - Init
    init(
        state: BadgeState,
        xButtonImage: Image = Image("Modal/btn_close"),
        badgeSize: CGFloat,
        badgeTitle: String,
        badgeTitleColor: Color = .black,
        badgeDescription: String,
        badgeDescriptionColor: Color = .gray060
    ) {
        self.state = state
        self.xButtonImage = xButtonImage
        self.badgeSize = badgeSize
        self.badgeTitle = badgeTitle
        self.badgeTitleColor = badgeTitleColor
        self.badgeDescription = badgeDescription
        self.badgeDescriptionColor = badgeDescriptionColor
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
                .padding(.horizontal, 15)
                
                Spacer().frame(height: 8)
                
                // 상태에 따른 뱃지 뷰 표시
                Group {
                    switch state {
                    case .badgeUnlocked(let progress, let icon):
                        VStack {
                            CircleProgressView(progress: progress, size: badgeSize, icon: icon)
                            
                            Spacer()
                        }
                        .frame(width: 130, height: 130)

                    case .badgeLocked:
                            LockBadgeView(size: badgeSize)
                    }
                }
                    
                    Spacer().frame(height: 16)
                    
                    /// 뱃지 제목 메시지
                    Text(badgeTitle)
                        .foregroundColor(badgeTitleColor)
                        .font(.dsTitle3)
                    
                    Spacer().frame(height: 8)
                    
                    /// 모달 설명 메시지
                    Text(badgeDescription)
                        .padding(.horizontal, 45)
                        .foregroundColor(badgeDescriptionColor)
                        .font(.dsFootnote)
                        .fixedSize(horizontal: false, vertical: true) // 텍스트의 줄바꿈 허용
                        .multilineTextAlignment(.center) // 텍스트 중앙 정렬
                    
                    Spacer().frame(height: 32)
                    
                    Button(action: {
                        print("횟수 버튼")
                    }, label: {
                        Text("\(state.progressNumText)/10회")
                            .font(.dsHeadline)
                            .foregroundColor(state.buttonTextColor)
                            .frame(width: 77, height: 34) // 버튼 크기
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(state.buttonBorderColor, lineWidth: 1) // 버튼 테두리
                            )
                    })
                    .background(state.buttonColor)
                    .cornerRadius(10)
                }
                .frame(width: 270, height: 338)
                .padding(.bottom, 16)
                .background(.white)
                .cornerRadius(10)
        }
    }
}

#Preview("뱃지 획득 중 ~ 획득 완료") {
    ModalViewBadge(
        state: .badgeUnlocked(progress: 0.7, icon: Image(systemName: "star.fill")),
        badgeSize: 130,
        badgeTitle: "혼밥러",
        badgeDescription: "'혼밥' 해시태그를 10회 이상 사용 시 획득할 수 있습니다."
        )
}
#Preview("뱃지 잠금") {
    ModalViewBadge(
        state: .badgeLocked,
        badgeSize: 130,
        badgeTitle: "혼밥러",
        badgeDescription: "'혼밥' 해시태그를 10회 이상 사용 시 획득할 수 있습니다."
        )
}
