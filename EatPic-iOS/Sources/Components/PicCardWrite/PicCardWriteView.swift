//
//  PicCardWrite.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/25/25.
//

import SwiftUI

private enum Metrics {
    static let hPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 24
    static let smallSpacing: CGFloat = 20
    static let shareSpacing: CGFloat = 34
    static let textAreaHeight: CGFloat = 150
    static let buttonWidth: CGFloat = 361
    static let buttonHeight: CGFloat = 48
    static let buttonCorner: CGFloat = 10
}

struct PicCardWriteView: View {
    @EnvironmentObject private var container: DIContainer
    
    let primaryButtonText: String
    let recipeLinkTitle: String
    let storeLocationTitle: String
    let recipeLinkTitleColor: Color
    let storeLocationTitleColor: Color
    
    let onPrimaryButtonTap: (() -> Void)?
    let onAddReceiptTap: (() -> Void)?
    let onAddStoreLocationTap: (() -> Void)?

    @Binding var myMemo: String
    @Binding var receiptDetail: String
    @Binding var isSharedToFeed: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: Metrics.sectionSpacing)

            memoSection
            
            Spacer().frame(height: Metrics.sectionSpacing)
            
            recipeSection

            Spacer().frame(height: Metrics.smallSpacing)

            actionButtonsSection
            
            ShareToFeedButton(isOn: $isSharedToFeed)

            Spacer().frame(height: Metrics.shareSpacing)

            footerPrimaryButton
        }
        .padding(.horizontal, Metrics.hPadding)
    }
    
    @ViewBuilder
    private var memoSection: some View {
        Text("나의 메모")
            .font(.dsHeadline)
            .foregroundStyle(Color.gray080)

        Spacer().frame(height: 8)

        TextAreaView(
            text: $myMemo,
            placeholder: "잇친들과 공유할 나의 메모를 입력해주세요.",
            height: Metrics.textAreaHeight
        )
    }
    
    @ViewBuilder
    private var recipeSection: some View {
        Text("레시피 내용")
            .font(.dsHeadline)
            .foregroundStyle(Color.gray080)

        Spacer().frame(height: 8)

        TextAreaView(
            text: $receiptDetail,
            placeholder: "잇친들과 공유할 레시피 내용을 입력해주세요.",
            height: Metrics.textAreaHeight
        )
    }

    @ViewBuilder
    private var actionButtonsSection: some View {
        AddButtonView(
            btnImage: Image("PicCardWrite/ic_record_link"),
            btnTitle: recipeLinkTitle,
            titleColor: recipeLinkTitleColor,
            action: {
                onAddReceiptTap?()
            }
        )

        AddButtonView(
            btnImage: Image("PicCardWrite/ic_record_map"),
            btnTitle: storeLocationTitle,
            titleColor: storeLocationTitleColor,
            action: {
                onAddStoreLocationTap?()
            }
        )
    }

    @ViewBuilder
    private var footerPrimaryButton: some View {
        PrimaryButton(
            color: .green060,
            text: primaryButtonText,
            font: .dsTitle3,
            textColor: .white,
            width: Metrics.buttonWidth,
            height: Metrics.buttonHeight,
            cornerRadius: Metrics.buttonCorner
        ) {
            guard let onPrimaryButtonTap else {
                // 경고 안내 모달 띄우기
                return
            }
            onPrimaryButtonTap()
        }
    }
}
// MARK: 레시피 링크 또는 식당 위치 추가 공용버튼 뷰
private struct AddButtonView: View {
    let btnImage: Image
    let btnTitle: String
    let titleColor: Color
    let action: () -> Void
    
    // MARK: - Init
    init(
        btnImage: Image,
        btnTitle: String,
        titleColor: Color = .gray080,
        action: @escaping () -> Void
    ) {
        self.btnImage = btnImage
        self.btnTitle = btnTitle
        self.titleColor = titleColor
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                btnImage
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Spacer().frame(width: 8)
                
                Text(btnTitle)
                    .font(.dsBody)
                    .foregroundStyle(titleColor)
                
                Spacer()
                
                Image("PicCardWrite/add_btn")
                
                Spacer().frame(width: 12)
            }
        })
        .padding(.vertical, 18)
    }
}

// MARK: 피드 공유 버튼 뷰
private struct ShareToFeedButton: View {
    @Binding var isOn: Bool
    
    // MARK: - Init
    init(
        isOn: Binding<Bool>
    ) {
        self._isOn = isOn
    }

    var body: some View {
        HStack {
            Image("PicCardWrite/ic_record_share")
                .resizable()
                .frame(width: 24, height: 24)
            
            Spacer().frame(width: 8)
            
            Text("피드에 공유하기")
                .font(.dsBody)
                .foregroundStyle(Color.gray080)
            
            Spacer().frame(width: 12)
                     
            Text("피드에 공유하기")
                .font(.dsCaption1)
                .foregroundStyle(Color.gray060)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .pink060))
                .labelsHidden()
                
            Spacer().frame(width: 6)
        }
        .padding(.vertical, 18)
    }
}
