//
//  MyBadgeStatusHomeView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct MyBadgeStatusHomeView: View {
    @EnvironmentObject private var container: DIContainer
    @ObservedObject var viewModel: MyBadgeStatusViewModel
    @Binding var selectedBadge: MyBadgeStatusViewModel.BadgeItem?
    @Binding var showingBadgeModal: Bool
    
    // MARK: - Body
    var body: some View {
        VStack {
            titleBar
            
            badgeScroll
        }
        .padding(.top, 16)
        .padding(.horizontal, 19)
        .frame(height: 202)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    // MARK: 해당 뷰의 상단 제목 바
    private var titleBar: some View {
        HStack {
            Text("나의 뱃지 현황")
                .font(.dsTitle3)
                .foregroundStyle(Color.gray080)
            
            Spacer()
            
            Button(action: {
                container.router.push(.myBadgeStatusAll)
            }, label: {
                Text("전체보기 >")
                    .foregroundStyle(Color.green060)
                    .font(.dsSubhead)
            })
        }
    }

    // MARK: 뱃지 스크롤 뷰
    private var badgeScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(viewModel.badgeItems) { badgeItem in
                    BadgeView(
                        state: badgeItem.state,
                        badgeName: badgeItem.name
                    )
                    .scaleEffect(0.77)
                    .frame(width: 100)
                    .onTapGesture {
                        selectedBadge = badgeItem
                        showingBadgeModal = true
                    }
                }
            }
        }
    }
}
