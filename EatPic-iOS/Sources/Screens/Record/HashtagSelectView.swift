//
//  HashtagSelectView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import SwiftUI

struct HashtagSelectView: View {
    // MARK: - Property
    // @State 'private' : 이 변수는 '이 뷰 안에서만' 바뀌고, 바뀔 때마다 뷰를 다시 그려줘
    @State private var selectedHashtags: Set<String> = [] // 해시태그 이름 중복 방지를 위한 Set 사용
    
    // 해시태그 데이터
    // let: 바뀌지 않는 값 (해시태그 목록은 변경이 필요없기에)
    let hashtags = [
        "야식", "브런치", "혼밥", "집밥",
        "식단관리", "자취생", "건강", "맛집",
        "비건", "한식", "양식", "중식", "일식"
    ]
    
    // MARK: - Body
    var body: some View {
        VStack {
            // 캐릭터 이미지
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)
            
            Spacer().frame(height: 36)
            
            // 거대 텍스트
            Text("식사와 연관된\n해시태그를 선택해주세요")
                .font(.dsTitle2)
                .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
            
            Spacer().frame(height: 8)
            
            // 작은 텍스트
            Text("최대 3개를 선택할 수 있어요")
                .font(.dsFootnote)
                .foregroundColor(.gray060)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 32)

            // 해시태그 버튼들
            // selectedHashtags에는 선택된 해시태그가 담기므로
            // 이걸 나중에 써먹으면 될거 같습니다...
            VStack(alignment: .leading, spacing: 8) {
                // 첫 번째 행 (4개)
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { index in
                        HashtagButton(
                            hashtagName: hashtags[index],
                            isSelected: selectedHashtags.contains(hashtags[index])
                                // HashtagButton에게 “이 버튼이 선택된 상태인지 아닌지”를 알려주는 코드
                                // hashtags[index] : 현재 반복 중인 해시태그
                                // selectedHashtags : 사용자가 선택한 해시태그들 (Set<String>)
                                // .contains(...) : 특정 해시태그가 선택된 상태인가??
                                // → 지금 이 해시태그가 선택된 리스트 안에 있는가??
                                // (있으면 true → 버튼은 선택된 UI, 없으면 false → 버튼은 미선택 UI)
                        ) { // action: (trailing closure로 인한 생략)
                            if selectedHashtags.contains(hashtags[index]) {
                                selectedHashtags.remove(hashtags[index])
                            } else {
                                selectedHashtags.insert(hashtags[index])
                            }
                        }
                    }
                }
                
                // 두 번째 행 (4개)
                HStack(spacing: 8) {
                    ForEach(4..<8, id: \.self) { index in
                        HashtagButton(
                            hashtagName: hashtags[index],
                            isSelected: selectedHashtags.contains(hashtags[index])
                        ) {
                            if selectedHashtags.contains(hashtags[index]) {
                                selectedHashtags.remove(hashtags[index])
                            } else {
                                selectedHashtags.insert(hashtags[index])
                            }
                        }
                    }
                }
                
                // 세 번째 행 (5개)
                HStack(spacing: 8) {
                    ForEach(8..<13, id: \.self) { index in
                        HashtagButton(
                            hashtagName: hashtags[index],
                            isSelected: selectedHashtags.contains(hashtags[index])
                        ) {
                            if selectedHashtags.contains(hashtags[index]) {
                                selectedHashtags.remove(hashtags[index])
                            } else {
                                selectedHashtags.insert(hashtags[index])
                            }
                        }
                    }
                }
            }
            
            Spacer().frame(height: 80)
            
            // 직접 추가하기 버튼
            Button(action: {
                // TODO: BottomSheetView 띄우기 - 어케 하지... (제꺼 바텀 시트는 어딧죠 승윤님 ㅜㅜ)
                
            }, label: {
                HStack {
                    Text("직접 추가하기")
                        .font(.dsSubhead)
                        .foregroundColor(.gray060)
                    
                    Spacer()
                    
                    Image("Record/btn_record_add")
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(width: 135, height: 38)
                .background(Color.gray020)
                .cornerRadius(10)
            })
            
            Spacer().frame(height: 51)
            
            // 최하단 버튼
            PrimaryButton(
                color: .green060,
                text: "확인",
                font: .dsTitle3,
                textColor: .white,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                // TODO: 다음 화면으로 이동하는 로직 추가
            }
        }
        .padding(.horizontal, 16)
        // TODO: BottomSheetView 구현이 되어야 하는디요? 그리고 정확히 어떻게 불러오는지...
    }
}

// MARK: 해시태그 버튼
private struct HashtagButton: View {
    let hashtagName: String
    let isSelected: Bool
    let hashtagBtnAction: () -> Void
    
    var body: some View {
        Button(action: hashtagBtnAction) {
            Text("#\(hashtagName)")
                .font(.dsCallout)
                .foregroundStyle(isSelected ? Color.green060 : Color.gray050)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isSelected ? Color.green010 : Color.white)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(isSelected ? Color.green060 : Color.gray050, lineWidth: 1)
                )
        }
    }
}

#Preview {
    HashtagSelectView()
}
