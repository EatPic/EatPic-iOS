//
//  BlockedAccountView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/14/25.
//

import SwiftUI

struct BlockedAccountView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { _ in
                    blockedAccount
                }
            }
        }
        .customNavigationBar {
            Text("차단된 계정")
        } right: {
            EmptyView()
        }
    }
    
    // MARK: 차단된 계정
    private var blockedAccount: some View {
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
                print("차단 해제")
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
