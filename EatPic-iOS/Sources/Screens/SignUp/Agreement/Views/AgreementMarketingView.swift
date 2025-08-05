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
            
            Spacer().frame(height: 20)
            
            Text("마케팅 정보 수신 동의")
                .font(.dsTitle2)
            
            Text(TermsOfMarketing.content)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray080)
            
            Spacer()
        }
        .padding(.horizontal, 17)
    }
}

#Preview {
    AgreementMarketingView()
}
