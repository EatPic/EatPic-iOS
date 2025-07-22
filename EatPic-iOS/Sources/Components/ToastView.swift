//
//  ToastView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/21/25.
//

import SwiftUI

/// 화면 하단에 표시되는 공용 토스트 뷰
/// 전달받은 'title'을 텍스트로 표시하며, 닫기 버튼을 제공
struct ToastView: View {
    /// 토스트에 표시할 제목
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            // 왼쪽 아이콘
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.pink060)
            
            Spacer()
            
            // 토스트 뷰 제목
            Text(title)
                .font(.dsHeadline)
                .foregroundStyle(Color.white)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(Color.gray060)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
