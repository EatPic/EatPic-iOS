//
//  MainHomeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/22/25.
//

import SwiftUI

struct MainHomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                TopView()
                
                Spacer().frame(height: 28)
                
                MealStatusView()
                
                Spacer().frame(height: 24)
                
                RecomPicCard()
                
                Spacer().frame(height: 24)
                
                BadgeStatusView()
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .background(Color.gray030.ignoresSafeArea())
        .customNavigationBar(title: {
            HStack {
                Circle().frame(width: 32, height: 32)
                Text("Title")
            }
        }, right: {
            Button {
                print("오른쪽 버튼")
            } label: {
                Image(systemName: "gearshape")
            }
        })
    }
}

// 상단 제목 뷰
struct TopView: View {
    var body: some View {
        HStack(alignment: .top) {
            Text("안녕하세요. 잇콩님\n오늘도 Pic 카드를 기록해볼까요?")
                .font(.dsTitle2)
                .kerning(-0.44) // 22 * -0.02 = -0.44
            
            Spacer()
            
            Button {
                print("캘린더로 이동")
            } label: {
                Image("Home/btn_home_calender")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Spacer().frame(width: 16)
            
            Button {
                print("알림으로 이동")
            } label: {
                Image("Home/btn_home_notification")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
        }
    }
}

#Preview {
    MainHomeView()
}
