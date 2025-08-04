//
//  MypageCarView.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/3/25.
//

import SwiftUI

/// 마이페이지 내 카드 형식의 항목을 표시하는 뷰입니다.
///
/// - Parameters:
///   - iconName: 카드 상단에 표시될 아이콘의 이미지 이름 (Asset 이름 또는 SF Symbol)
///   - title: 카드의 카테고리 제목 텍스트 (예: "전체 Pic 카드")
///   - description: 카드에 대한 간단한 설명 텍스트 (예: "나의 전체 Pic 카드 확인해보기")
///   - countText: 카드 우측에 표시될 수치 정보 (예: "0개")
///   - action: 카드 전체를 탭했을 때 실행될 동작을 정의하는 클로저
struct MyPageCardView: View {
    let iconName: String
    let title: String
    let description: String
    let countText: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                // 좌측: 아이콘 + 텍스트
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(iconName)
                        
                        Text(title)
                            .font(.dsFootnote)
                            .foregroundColor(.gray080)
                    }
                    Text(description)
                        .font(.dsTitle3)
                        .foregroundColor(.black)
                }

                Spacer()
                
                // 우측: 숫자 + 화살표
                HStack(spacing: 4) {
                    Text(countText)
                        .foregroundColor(.pink060)
                        .font(.dsHeadline)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 0)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MyPageCardView(
            iconName: "card",
            title: "전체 Pic 카드",
            description: "나의 전체 Pic 카드 확인해보기",
            countText: "0개"
        ) {
            print("전체 카드 클릭")
        }

        MyPageCardView(
            iconName: "bookmark",
            title: "저장한 Pic 카드",
            description: "내가 저장한 Pic 카드 확인해보기",
            countText: "0개"
        ) {
            print("저장 카드 클릭")
        }

        MyPageCardView(
            iconName: "badge",
            title: "활동 배지",
            description: "지금까지 모은 뱃지 확인해보기",
            countText: "0개"
        ) {
            print("배지 클릭")
        }
    }
    .padding()
}
