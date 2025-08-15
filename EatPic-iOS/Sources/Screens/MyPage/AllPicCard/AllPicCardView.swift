//
//  AllPicCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/15/25.
//

import SwiftUI

struct AllPicCardView: View {
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ], spacing: 8) {
                ForEach(0..<30, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gray020)
                        .frame(width: 118, height: 118)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    AllPicCardView()
}
