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
