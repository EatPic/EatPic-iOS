//
//  Link.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//
import SwiftUI

struct CopyLinkButton: View {
    let linkURL: String
    
    var body: some View {
        Button(action: {
            copyToClipboard()
        }) {
            HStack {
                Image(systemName: "link")
                Text("링크 복사")
            }
            .foregroundColor(.green060)
        }
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = linkURL
        
        // 복사 완료 알림 (선택사항)
        print("링크가 복사되었습니다: \(linkURL)")
    }
}
