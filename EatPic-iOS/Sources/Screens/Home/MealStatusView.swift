//
//  MealStatusView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/22/25.
//

import SwiftUI

enum MealType: String, CaseIterable {
    case breakfast = "아침"
    case lunch = "점심"
    case dinner = "저녁"
}

struct MealStatusView: View { 
    var body: some View {
          
            VStack {
                
                // 상단 제목
                HStack {
                    Text("오늘의 식사 현황")
                        .font(.dsTitle3)
                        .foregroundColor(.gray080)
                    
                    Spacer().frame(height: 24)
                    
                    Button(action: {
                        print("이거 수정하기 버튼 띄우는 법을 잘 모르겠어요")
                    }, label: {
                        Image("Home/btn_home_ellipsis")
                    })
                }
                
                Spacer().frame(height: 24)
                
                // 아침~간식 버튼? 사각형 + 사진 추가/삭제
                // 하드 코딩함
                HStack(spacing: 6) {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.gray030)
                            
                            Text("아침")
                                .font(.dsBold15)
                                .foregroundColor(.gray060)
                        }
                        .frame(width: 60, height: 26)
                        
                        Spacer().frame(height: 10)
                        
                        AddMealView()
                    }
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.gray030)
                            
                            Text("점심")
                                .font(.dsBold15)
                                .foregroundColor(.gray060)
                        }
                        .frame(width: 60, height: 26)
                        
                        Spacer().frame(height: 10)
                        
                        AddMealView()
                    }
                                        
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.gray030)
                            
                            Text("저녁")
                                .font(.dsBold15)
                                .foregroundColor(.gray060)
                        }
                        .frame(width: 60, height: 26)
                        
                        Spacer().frame(height: 10)
                        
                        AddMealView()
                    }
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.gray030)
                            
                            Text("간식")
                                .font(.dsBold15)
                                .foregroundColor(.gray060)
                        }
                        .frame(width: 60, height: 26)
                        
                        Spacer().frame(height: 10)
                        
                        AddMealView()
                    }
                    
                    Spacer()
                }
                
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 19)
            .background(.white)
            .cornerRadius(15)
        }
}

//
//struct HomeView1: View {
//    var body: some View {
//        VStack {
//            Text("View1")
//            
//            
//            Text("View1")
//            Text("View1")
//        }
//    }
//}
//
//
///fileprivate struct View1: View {
//
//}
//
///fileprivate struct View2: View {
//    
//}



//
struct AddMealView: View {
    var body: some View {
        VStack {

            // 사진 추가 ~ 이미지
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray020)
                    .frame(width: 76, height: 76)
                
                Image("Home/btn_home_add")
                
            }
        }
    }
}

#Preview {
    MealStatusView()
}
