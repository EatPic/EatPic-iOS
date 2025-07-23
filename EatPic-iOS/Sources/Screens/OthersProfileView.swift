//
//  OthersProfileView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/24/25.
//

import SwiftUI

struct OthersProfileView: View {
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0), spacing: 4),
        GridItem(.flexible(minimum: 0), spacing: 4),
        GridItem(.flexible(minimum: 0), spacing: 4)
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                userProfileView()
                Spacer().frame(height: 16)
                
                PrimaryButton(
                    color: .green060,
                    text: "팔로우",
                    font: .dsBold15,
                    textColor: .white,
                    width: 109,
                    height: 28,
                    cornerRadius: 6,
                    action: {
                        print("follow")
                    })
                Spacer().frame(height: 19)
                
                userFeedView()
            }
            .customNavigationBar(title: {
                Text("")
            }, right: {
                Menu {
                    Button(role: .destructive) { } label: {
                        Label("차단하기", systemImage: "hand.raised.slash")
                    }
                    Button(role: .destructive) {} label: {
                        Label("신고하기", systemImage: "info.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            })
        }
        .scrollIndicators(.hidden)
    }
    
    private func userProfileView() -> some View {
        VStack {
            Spacer().frame(height: 8)
            ProfileImageView(image: Image(systemName: "circle.fill"),size: 100)
        
            Spacer().frame(height: 16)
            
            Text("닉네임")
                .font(.dsTitle3)
                .foregroundStyle(Color.gray080)
            Text("@아이디")
                .font(.dsSubhead)
                .foregroundStyle(Color.gray060)
            Spacer().frame(height: 18)
            
            Text("소개글입니다")
                .font(.dsCaption1)
                .foregroundStyle(Color.gray060)
            Spacer().frame(height: 16)
            
            followerCountView()
            Spacer().frame(height: 10)
        }
    }
    
    private func followerCountView() -> some View {
        HStack(spacing: 80) {
            VStack {
                Text("0")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("Pic 카드")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
            
            VStack {
                Text("0")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("팔로워")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
            
            VStack {
                Text("0")
                    .font(.dsTitle3)
                    .foregroundStyle(Color.black)
                Text("팔로잉")
                    .font(.dsCaption1)
                    .foregroundStyle(Color.gray080)
            }
        }
    }
    
    private func userFeedView() -> some View {
        LazyVGrid(columns: columns, spacing: 4, content: {
            ForEach(0..<10) { index in
                Rectangle()
                    .fill(Color.gray030)
                    .aspectRatio(1, contentMode: .fit)
            }
        })
        .padding(.horizontal, 16)
    }
}

#Preview {
    OthersProfileView()
}
