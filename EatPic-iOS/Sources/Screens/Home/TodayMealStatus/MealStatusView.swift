//
//  MealStatusView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/22/25.
//

import SwiftUI

struct MealStatusView: View {
    var body: some View {
        ZStack {
            
            Text("오늘의 식사 현황").font(.headline)
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image(systemName: "ellipsis")
                            }
            
        }
    }
}

#Preview {
    MealStatusView()
}
