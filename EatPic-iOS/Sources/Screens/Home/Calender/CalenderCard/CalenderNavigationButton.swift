////
////  CalenderNavigationButton.swift
////  EatPic-iOS
////
////  Created by 이은정 on 7/23/25.
////
//
//import SwiftUI
//
//// CalenderCard 뷰의 공통 버튼 뷰
///// - Parameters:
/////   - buttonName: 네비게이션 버튼 역할 이름
//struct CalenderNavigationButton: View {
//    let buttonName: String
//    
//    var body: some View {
//        HStack {
//            Text(buttonName)
//                .font(.dsHeadline)
//                .kerning(-0.44) // 22 * -0.02 = -0.44
//            
//            Spacer()
//            
//            Button {
//                print("\(buttonName)(으)로 이동")
//            } label: {
//                Image("Home/btn_home_next")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//            }
//        }
//        .padding(.horizontal, 24)
//        .padding(.vertical, 17)
//        .background(Color.white)
//    }
//}
//
//#Preview {
//    CalenderNavigationButton(buttonName: "레시피 링크")
//}


//
//  CalenderNavigationButton.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

// CalenderCard 뷰의 공통 버튼 뷰
/// - Parameters:
///   - buttonName: 네비게이션 버튼 역할 이름
///   - action: 버튼 클릭 시 실행할 액션 클로저
struct CalenderNavigationButton: View {
    let buttonName: String
    let action: () -> Void
    
    init(
        buttonName: String,
        action: @escaping () -> Void
    ) {
        self.buttonName = buttonName
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text(buttonName)
                .font(.dsHeadline)
                .kerning(-0.44) // 22 * -0.02 = -0.44
            
            Spacer()
            
            Button(action: action) {
                Image("Home/btn_home_next")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 17)
        .background(Color.white)
    }
}

#Preview {
    CalenderNavigationButton(
        buttonName: "레시피 링크"
    ) {
        print("레시피 링크로 이동")
    }
}
