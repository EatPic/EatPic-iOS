//
//  ReciptDetailCardView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/14/25.
//

import SwiftUI

struct RecipeDetailCardView: View {
    /// `RecipeDetailCardView`는 레시피 정보와 해시태그, 링크 및 내비게이션 버튼을 포함한 카드 뷰입니다.
    /// 이미지 위에 오버레이 형태로 텍스트와 버튼이 배치되며, 정사각형 형태로 구성되어 피드나 상세뷰 등에 활용됩니다.
    /// - Parameters:
    ///   - backgroundImage: 카드의 배경으로 표시될 이미지입니다.
    ///   - hashtags: 상단에 표시될 해시태그 문자열 배열입니다. (예: ["#아침", "#다이어트"])
    ///   - recipeDescription: 레시피 설명 텍스트입니다.
    ///   - linkURL: 외부 웹페이지로 연결될 URL. nil일 경우 버튼이 표시되지 않습니다.
    ///   - naviButtonAction: 위치 기반 길찾기 등 내비게이션 버튼을 눌렀을 때 실행할 액션. nil일 경우 버튼이 표시되지 않습니다.
    ///   - naviLabel: 내비게이션 버튼에 표시될 라벨 텍스트. `naviButtonAction`이 nil일 경우 함께 무시됩니다.
    let backgroundImage: Image
    let hashtags: [String]
    let recipeDescription: String
    let linkURL: URL?
    let naviButtonAction: (() -> Void)?
    let naviLabel: String?
    
    @Environment(\.openURL) private var openURL
    
    // MARK: init
    init(
        backgroundImage: Image,
        hashtags: [String],
        recipeDescription: String,
        linkURL: URL? = nil,
        naviButtonAction: (() -> Void)? = nil,
        naviLabel: String? = nil
    ) {
        self.backgroundImage = backgroundImage
        self.hashtags = hashtags
        self.recipeDescription = recipeDescription
        self.linkURL = linkURL
        self.naviButtonAction = naviButtonAction
        self.naviLabel = naviLabel
    }
    
    // MARK: body
    var body: some View {
        ZStack {
            let screenWidth = UIScreen.main.bounds.width
            
            // 배경 이미지
            backgroundImage
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenWidth)
                .clipped()
                .cornerRadius(20)
                .foregroundStyle(.black.opacity(0.7))
            
            VStack(alignment: .leading) {
                // 해시태그
                HStack(spacing: 4) {
                    ForEach(hashtags, id: \.self) { tag in
                        Text(tag)
                            .font(.koBold(size: 15))
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(.black)
                                    .stroke(.white, lineWidth: 1)
                            )
                    }
                }
                .padding(.leading, 17)
                
                Spacer()
                
                // 레시피 제목
                Text("레시피")
                    .font(.koBold(size: 22))
                    .foregroundStyle(.white)
                    .padding(.leading, 20)
                
                Spacer().frame(height: 19)
                
                // 레시피 설명
                Text(recipeDescription)
                    .font(.koRegular(size: 13))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                // 커스텀 하단 콘텐츠 (버튼들 등)
                HStack {
                    if let linkURL = linkURL {
                        Button {
                            openURL(linkURL)
                        } label: {
                            Image("icon_link")
                                .padding(5)
                                .background(
                                    Circle().fill(Color.white)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    if let naviAction = naviButtonAction,
                       let naviLabel = naviLabel {
                        Button(action: naviAction) {
                            HStack(spacing: 4) {
                                Image("icon_navi")
                                Text(naviLabel)
                                    .font(.koBold(size: 15))
                                    .foregroundStyle(Color.gray080)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .background(
                                Color.white.cornerRadius(50)
                            )
                        }
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 17)
            }
            .padding(.top, 19)
            .padding(.bottom, 23)
            .frame(height: screenWidth)
        }
    }
}

#Preview {
    RecipeDetailCardView(
        backgroundImage: Image(systemName: "square.fill"),
        hashtags: ["#아침", "#저탄고지", "#다이어트"],
        recipeDescription: "아보카도와 토마토, 그리고 닭가슴살로 구성된 간단한 레시피입니다.",
        linkURL: URL(string: "https://www.example.com"),     // 없으면 nil
        naviButtonAction: {
            print("맵뷰 실행")
        },
        naviLabel: "샐러디 한성대점"
    )
}
