//
//  AgreementServiceView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/1/25.
//

import SwiftUI

struct AgreementServiceView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 44) {
            
            Spacer().frame(height: 20)
            
            Text("이용약관 동의 (필수)")
                .font(.dsTitle2)
            
            Text(TermsOfService.content)
                .font(.dsSubhead)
                .foregroundStyle(Color.gray080)
            
            Spacer()
        }
        .padding(.horizontal, 17)
    }
}

#Preview {
    AgreementServiceView()
}
