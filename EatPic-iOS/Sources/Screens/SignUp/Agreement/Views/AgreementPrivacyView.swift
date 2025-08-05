//
//  AgreementPrivacyView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/1/25.
//

import SwiftUI

struct AgreementPrivacyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 44) {
            
            Spacer().frame(height: 20)
            
            Text("개인정보 수집 및 이용 동의 (필수)")
                .font(.dsTitle2)
            
            Text(TermsOfPrivacy.content)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray080)
            
            Spacer()
        }
        .padding(.horizontal, 17)
    }
}

#Preview {
    AgreementPrivacyView()
}
