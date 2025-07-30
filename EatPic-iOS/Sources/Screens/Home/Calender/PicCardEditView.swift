//
//  PicCardEditView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

struct PicCardEditView: View {
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        VStack {
            // FIXME: 아마 삭제 예정 (x버튼 눌렀을때 네비게이션 이동 방식이 왼쪽이 아닌 오른쪽으로 이동하기에 그냥 customNavigationBar 쓰는게 나을듯?
//            // 상단바
//            HStack {
//                Spacer()
//                
//                Text("수정하기")
//                    .font(.dsTitle2)
//                
//                Spacer().frame(width: 119)
//                
//                Button(action: {
//                    // TODO: CalenderCardView로 Navigation
//                    container.router.push(.calenderCardView)
//                }, label: {
//                    Image("Home/btn_home_close")
//                })
//            }
//            .padding(.horizontal, 16)
            
            PicCardWriteView()
        }
        .customNavigationBar(title: {
            HStack {
                Text("알림")
            }
        }, right: {
            EmptyView()
        })
    }
}

#Preview {
    PicCardEditView()
}
