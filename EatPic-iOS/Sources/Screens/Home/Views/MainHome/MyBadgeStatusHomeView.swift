//
//  MyBadgeStatusHomeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct MyBadgeStatusHomeView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel = MyBadgeStatusViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("나의 뱃지 현황")
                    .font(.dsTitle3)
                    .foregroundColor(.gray080)
                
                Spacer()
                
                Button(action: {
                    container.router.push(.myBadgeStatusAll)
                    print("전체보기")
                }, label: {
                    Text("전체보기 >")
                        .foregroundStyle(Color.green060)
                        .font(.dsSubhead)
                })
            }
            
            // 뱃지 리스트
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    
                    ForEach(viewModel.badgeItems) { badgeItem in
                        BadgeView(
                            state: badgeItem.state,
                            badgeName: badgeItem.name
                        )
                        .scaleEffect(0.77)
                        .frame(width: 100)
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 19)
        .frame(height: 202)
        .background(.white)
        .cornerRadius(15)
    }
}

#Preview {
    MyBadgeStatusHomeView()
        .environmentObject(DIContainer())
}
