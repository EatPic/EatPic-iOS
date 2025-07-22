//
//  PicCardView.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/12/25.
//

import SwiftUI

/// - Parameters:
///   - profileImage: 프로필 이미지
///   - profileID: 프로필 아이디
///   - time: 픽카드 업로드 시간
///   - menuContent: 메뉴버튼(eclipsis) 클릭 시 나타날 버튼목록 커스텀
///   - postImage: 업로드 이미지
///   - myMemo: 사용자가 작성하는 '나의 메모'
struct PicCardView<Content: View>: View {
    
    // MARK: property
    let profileImage: Image
    let profileID: String
    let time: String
    let menuContent: () -> Content
    let postImage: Image
    let myMemo: String
    
    // MARK: init
    init(
        profileImage: Image,
        profileID: String,
        time: String,
        @ViewBuilder menuContent: @escaping () -> Content,
        postImage: Image,
        myMemo: String
    ) {
        self.profileImage = profileImage
        self.profileID = profileID
        self.time = time
        self.menuContent = menuContent
        self.postImage = postImage
        self.myMemo = myMemo
    }
    
    // MARK: body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 카드 상단 업로드 정보(프로필, 시간)
            HStack {
                profileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading) {
                    Text(profileID)
                        .font(.dsHeadline)
                        .foregroundStyle(Color.gray080)
                    Text(time)
                        .font(.dsFootnote)
                        .foregroundStyle(Color.gray060)
                }
                
                Spacer()
                
                Menu {
                    menuContent()
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.black)
                }
            }
                        
            // 업로드 이미지 (정사각형 + 모서리 둥글게)
            // 이미지의 사이즈는 기기의 화면 너비에 따라 달라지도록 설정 (화면 너비를 꽉채우도록)
            let screenWidth = UIScreen.main.bounds.width
            postImage
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit) // 정사각형 유지
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // 사용자 메모 (나의 메모)
            Text(myMemo)
                .font(.dsSubhead)
                .foregroundColor(.gray080)
        }
    }
}

#Preview {
    PicCardView(
        profileImage: Image(systemName: "circle.fill"),
        profileID: "아이디",
        time: "오후 6:29",
        menuContent: {
            Button(action: {
                print("사진 앱에 저장")
            }) {
                Label("사진 앱에 저장", systemImage: "square.and.arrow.down")
            }
            
            Button(action: {
                print("수정하기")
            }) {
                Label("수정하기", systemImage: "square.and.pencil")
            }
            
            // role을 destructive로 설정 시, 빨간 버튼으로 만들 수 있음
            Button(role: .destructive, action: {
                print("삭제하기")
            }) {
                Label("삭제하기", systemImage: "exclamationmark.bubble")
            }
        },
        postImage: Image(systemName: "square.fill"),
        myMemo: "오늘은 샐러드를 먹었습니다~ 아보카도를 많이 넣어 먹었어요~~~~~~다들 제 레시피 보고 따라 만들어주시기길......태그도 남겨주시기르를"
    )
}
