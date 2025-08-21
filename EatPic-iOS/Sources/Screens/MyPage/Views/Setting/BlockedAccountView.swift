//
//  BlockedAccountView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/14/25.
//

import SwiftUI

struct BlockedAccountView: View {
    @State private var showUnblockModal = false
    @State private var selectedNickname = "닉네임"
    @State private var selectedId = "아이디"
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { index in
                        blockedAccount(index: index)
                    }
                }
            }
            .customNavigationBar {
                Text("차단된 계정")
            } right: {
                EmptyView()
            }
            
            // 차단 해제 모달
            if showUnblockModal {
                DecisionModalView(
                    message: "\(selectedNickname)(@\(selectedId))님을 차단 해제하시겠어요?",
                    messageColor: .gray080,
                    leftBtnText: "아니오",
                    rightBtnText: "차단 해제",
                    rightBtnColor: .red050,
                    leftBtnAction: {
                        showUnblockModal = false
                        print("아니오 버튼 클릭, 모달 닫기 액션")
                    },
                    rightBtnAction: {
                        showUnblockModal = false
                        print("차단 해제 버튼 클릭, 모달닫기 액션")
                    }
                )
            }
        }
    }
    
    // MARK: 차단된 계정
    private func blockedAccount(index: Int) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.gray040)
                .frame(width: 47, height: 47)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("닉네임")
                    .font(.dsSubhead)
                
                Text("@아이디")
                    .font(.dsSubhead)
                    .foregroundStyle(Color.gray060)
            }
            
            Spacer()
            
            Button("차단 해제") {
                selectedNickname = "닉네임"
                selectedId = "아이디"
                showUnblockModal = true
            }
            .font(.dsBold13)
            .foregroundStyle(Color.gray050)
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(Color.gray030)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    BlockedAccountView()
}
