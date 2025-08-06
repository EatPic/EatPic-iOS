//
//  ReportBottomSheetView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 8/5/25.
//

import SwiftUI

struct ReportBottomSheetView: View {
    @Binding var isShowing: Bool
    let onReport: (String) -> Void
    
    // 신고 대상 (PicCard or Comment)
        let target: ReportTarget
    
    var body: some View {
        ScrollView {
            BottomSheetView(
                title: "신고하기",
                subtitle: {
                    VStack(spacing: 16) {
                        Text(target.subtitle)
                            .font(.dsTitle2)
                            .foregroundStyle(Color.gray080)
                        Text("회원님의 신고는 익명으로 처리됩니다")
                            .font(.dsFootnote)
                            .foregroundStyle(Color.gray060)
                    }
                },
                content: {
                    VStack(spacing: 0) {
                        ForEach(reportTypes, id: \.self) { reportType in
                            reportListView(reportType: reportType)
                        }
                    }
                })
            .padding(.top, 24)
        }
        .scrollIndicators(.hidden)
    }
    
    private func reportListView(reportType: String) -> some View {
        VStack(spacing: 0) {
            Divider().foregroundStyle(Color.gray030)
            HStack {
                Text(reportType)
                    .font(.dsBody)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray050)
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            .padding(.leading, 28)
            .padding(.trailing, 16)
            .contentShape(Rectangle())
            .onTapGesture {
                onReport(reportType)
            }
        }
    }
}
