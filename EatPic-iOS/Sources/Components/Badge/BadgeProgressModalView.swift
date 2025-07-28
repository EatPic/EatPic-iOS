//
//  ModalViewBadge.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/15/25.
//
import SwiftUI

/// 뱃지 상태에 따른 모달 뷰
/// - Parameters:
///   - badgeType : 현재 뱃지 상태에 따른 뱃지의 속성 정보(보여질 뱃지뷰, 버튼 색상, 버튼테두리색상, 버튼텍스트 색상, 뱃지 획득 횟수)를 담고 있는 열거형
///   - badgeSize : 뱃지뷰 사이즈입니다
///   - badgeTitle : 뱃지 이름 입니다
///   - badgeTitleColor: 뱃지 이름 텍스트 색상입니다
///   - badgeDescription: 뱃지 설명 입니다
///   - badgeDescriptionColor: 뱃지 설명 텍스트 색상
struct BadgeProgressModalView<T: ModalBadgeTypeProtocol>: View {
    
    // MARK: - Properties

    /// 현재 뱃지 상태 타입(Unlocked/Locked)
    let badgeType: T
    
    let closeBtnAction: () -> Void

    /// 뱃지뷰 사이즈
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
        badgeType: T,
        closeBtnAction: @escaping () -> Void,
        badgeSize: CGFloat,
        badgeTitle: String,
        badgeTitleColor: Color = .black,
        badgeDescription: String,
        badgeDescriptionColor: Color = .gray060
    ) {
        self.badgeType = badgeType
        self.closeBtnAction = closeBtnAction
        self.badgeSize = badgeSize
        self.badgeTitle = badgeTitle
        self.badgeTitleColor = badgeTitleColor
        self.badgeDescription = badgeDescription
        self.badgeDescriptionColor = badgeDescriptionColor
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        print("모달 나가기 동작")
                        closeBtnAction()
                    }, label: {
                        Image("Modal/btn_close")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    })
                }
                .padding(.horizontal, 15)

                Spacer().frame(height: 8)

                badgeType.badgeView
                    .frame(width: badgeSize, height: badgeSize)

                Spacer().frame(height: 16)

                Text(badgeTitle)
                    .foregroundColor(badgeTitleColor)
                    .font(.dsTitle3)

                Spacer().frame(height: 8)

                Text(badgeDescription)
                    .padding(.horizontal, 45)
                    .foregroundColor(badgeDescriptionColor)
                    .font(.dsFootnote)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 32)

                Button(action: {}, label: {
                    Text("\(badgeType.progressText)/10회")
                        .font(.dsHeadline)
                        .foregroundColor(badgeType.buttonTextColor)
                        .frame(width: 77, height: 34)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(badgeType.buttonBorderColor, lineWidth: 1)
                        )
                })
                .background(badgeType.buttonColor)
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
    BadgeProgressModalView(
        badgeType: BadgeModalType.badgeUnlocked(
            progress: 0.7,
            icon: Image(systemName: "star.fill")),
        closeBtnAction: { print("close") },
        badgeSize: 130,
        badgeTitle: "혼밥러",
        badgeDescription: "'혼밥' 해시태그를 10회 이상 사용 시 획득할 수 있습니다."
    )
}

#Preview("뱃지 잠금") {
    BadgeProgressModalView(
        badgeType: BadgeModalType.badgeLocked,
        closeBtnAction: { print("close") },
        badgeSize: 130,
        badgeTitle: "혼밥러",
        badgeDescription: "'혼밥' 해시태그를 10회 이상 사용 시 획득할 수 있습니다."
    )
}
