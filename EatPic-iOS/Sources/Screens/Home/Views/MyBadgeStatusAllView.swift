//
//  MyBadgeStatusAllView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct MyBadgeStatusAllView: View {
    
    let getBadgeStatus: String
    // TODO: 음 근데 이거 매개변수 처리하면 안되긴 하죠? 어떻게 각각의 progress 값을 각각 받아야 할지
    // 음 매개변수로 각각 받을수 잇게 모델안에 넣어서... 일단 나중에
    
    var body: some View {
        VStack {
            Spacer().frame(height: 32)
            
            HStack {
                Text("잇콩님이 획득한 배지 현황")
                    .font(.dsBody)
                    .foregroundColor(Color.gray080)
                
                Spacer().frame(width: 7)
                
                Group {
                    Text("\(getBadgeStatus)")
                        .font(.dsTitle3)
                        .foregroundColor(Color.green060)
                    
                    +
                    
                    Text("/10")
                        .font(.dsTitle3)
                        .foregroundColor(Color.gray060)
                }
            }
            
            // 획득 뱃지 현황
            // 5행 2열
            ScrollView {
                LazyVStack {
                    Spacer().frame(height: 32)
                    
                    // 1행
                    HStack {
                        BadgeView(
                            state: .progress(progress: 0.4,
                                             icon: Image(systemName: "star.fill")
                                            ),
                            badgeName: "혼밥러"
                        )
                        
                        Spacer().frame(width: 40)
                        
                        BadgeView(
                            state: .progress(progress: 0.4,
                                             icon: Image(systemName: "star.fill")
                                            ),
                            badgeName: "혼밥러"
                        )
                    }
                    
                    Spacer().frame(height: 24)
                    
                    // 2행
                    HStack {
                        BadgeView(
                            state: .progress(progress: 0.4,
                                             icon: Image(systemName: "star.fill")
                                            ),
                            badgeName: "혼밥러"
                        )
                        
                        Spacer().frame(width: 40)
                        
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                    }
                    
                    Spacer().frame(height: 24)
                    
                    // 3행
                    HStack {
                        BadgeView(
                            state: .progress(progress: 0.4,
                                             icon: Image(systemName: "star.fill")
                                            ),
                            badgeName: "혼밥러"
                        )
                        
                        Spacer().frame(width: 40)
                        
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                    }
                    
                    Spacer().frame(height: 24)
                    
                    // 4행
                    HStack {
                        BadgeView(
                            state: .progress(progress: 0.4,
                                             icon: Image(systemName: "star.fill")
                                            ),
                            badgeName: "혼밥러"
                        )
                        
                        Spacer().frame(width: 40)
                        
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                    }
                    
                    Spacer().frame(height: 24)
                    
                    // 5행
                    HStack {
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                        
                        Spacer().frame(width: 40)
                        
                        BadgeView(
                            state: .locked,
                            badgeName: "기록마스터"
                        )
                    }
                    
                    Spacer().frame(height: 48)
                    
                }
            }
        }
        .customNavigationBar {
            Text("활동 뱃지")
        } right: {
            EmptyView()
        }
    }
}

#Preview {
    MyBadgeStatusAllView(getBadgeStatus: "3")
}
