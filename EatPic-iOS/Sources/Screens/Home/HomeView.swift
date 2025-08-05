//
//  MainHomeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/22/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                Spacer().frame(height: 40)
                
                topBar
                
                MealStatusView()
                
                RecomPicCardHomeView()
                
                MyBadgeStatusHomeView()
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .background(Color.gray030.ignoresSafeArea())
    }
    
    private var topBar: some View {
        HStack(alignment: .top) {
            Text("안녕하세요. 잇콩님\n오늘도 Pic 카드를 기록해볼까요?")
                .font(.dsTitle2)
                .kerning(-0.44) // 22 * -0.02 = -0.44
            
            Spacer()
            
            Button {
                container.router.push(.calendar)
            } label: {
                Image("Home/btn_home_calender")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Spacer().frame(width: 16)
            
            Button {
                print("알림으로 이동")
                container.router.push(.notification)
            } label: {
                Image("Home/btn_home_notification")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    HomeView()
}
