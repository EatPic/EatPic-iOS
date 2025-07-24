//
//  BadgeStatusView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct BadgeStatusView: View {
    var body: some View {
        
        VStack {
            HStack {
                Text("나의 뱃지 현황")
                    .font(.dsTitle3)
                    .foregroundColor(.gray080)
                
                Spacer()
                
                Button(action: {
                    print("전체보기")
                }, label: {
                    Text("전체보기 >")
                        .foregroundStyle(Color.green060)
                        .font(.dsSubhead)
                })
            }
            
            Spacer().frame(height: 24)
            
            // 뱃지 리스트
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    Group {
                        
                        BadgeView(
                            state: .progress(progress: 0.4, icon: Image(systemName: "star.fill")),
                            badgeName: "혼밥러"
                        )
                        .scaleEffect(0.77)
                        .frame(width: 100)
                        
                        BadgeView(
                            state: .progress(progress: 0.4, icon: Image(systemName: "star.fill")),
                            badgeName: "혼밥러"
                        )
                        .scaleEffect(0.77)
                        .frame(width: 100)
                        
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                        .scaleEffect(0.77)
                        .frame(width: 100)
                        
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                        .scaleEffect(0.77)
                        .frame(width: 100)
                        
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                        .scaleEffect(0.77)
                        .frame(width: 100)
                        
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                        .scaleEffect(0.77)
                        .frame(width: 100)
                        
                    }

                }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 19)
//        .frame(height: 202)
        .background(.white)
        .cornerRadius(15)
    }
}

#Preview {
    BadgeStatusView()
}
