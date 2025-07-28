////
////  CalenderCardView.swift
////  EatPic-iOS
////
////  Created by 이은정 on 7/23/25.
////
//
//import SwiftUI
//
//struct CalenderCardView: View {
//    var body: some View {
//
//        Spacer().frame(height: 8)
//        
//        VStack {
//            // 상단바
//            RoundedRectangle(cornerRadius: 0)
//                .frame(height: 56)
//            
//            // 당일 식사 사진 띄워주는 Carousel 뷰
//            VStack {
//                Spacer().frame(height: 36)
//                
//                RoundedRectangle(cornerRadius: 20)
//                    .frame(width: 300, height: 300)
//                
//                Spacer().frame(height: 43)
//            }
//            
//            
//            // 레시피 링크 ~ 메모 등의 버튼 뷰 4개
//            ZStack {
//                // VStack은 기본적으로
//                // 각 자식 뷰 사이에 spacing을 주기 때문에
//                // spacing을 0으로 처리
//                VStack(spacing: 0) {
//                    
//                    CalenderNavigationButton(buttonName: "레시피 링크")
//                    
//                    Divider()
//                        .frame(width: .infinity)
//                    
//                    CalenderNavigationButton(buttonName: "식당 위치")
//                    
//                    Divider()
//                        .frame(width: .infinity)
//                    
//                    CalenderNavigationButton(buttonName: "나의 메모")
//                    
//                    Divider()
//                        .frame(width: .infinity)
//                    
//                    CalenderNavigationButton(buttonName: "레시피 내용")
//                }
//                .padding(.vertical, 8)
//            }
//            .background(Color.gray030.ignoresSafeArea())
//            
//            // 하단 뷰 (해당 피드 바로가기 버튼 존재)
//            VStack {
//                
//                Spacer().frame(height: 28)
//                
//                Button {
//                    print("해당 피드 바로가기 버튼 클릭")
//                } label: {
//                    HStack {
//                        Text("해당 피드 바로가기")
//                            .underline()
//                            .font(.dsSubhead)
//                            .foregroundStyle(Color.gray060)
//                    }
//                }
//            }
//            
//            Spacer()
//        }
//    }
//}
//
//#Preview {
//    CalenderCardView()
//}
