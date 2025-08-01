//
//  AgreementMarketingView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/1/25.
//

import SwiftUI

struct AgreementMarketingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 44) {
            Text("이용약관 동의 (필수)")
                .font(.dsTitle2)
            
            Text(TermsOfService.content)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray080)
        }
        .customCenterNavigationBar {
        }
        .padding(.horizontal, 17)
    }
}

#Preview {
    AgreementMarketingView()
}
