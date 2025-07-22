//
//  MainHomeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/22/25.
//

import SwiftUI

struct MainHomeView: View {
    var body: some View {
        
        VStack {
            
            MealStatusView()
            
                }
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

#Preview {
    MainHomeView()
}
