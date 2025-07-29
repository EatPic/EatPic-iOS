//
//  HashtagSelectionView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

struct HashtagSelectionView: View {
    
    // MARK: - Property
    
    /// 해시태그 선택 기능 및 상태를 관리하는 ViewModel
    @StateObject private var viewModel = HashtagSelectViewModel()
    
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
            VStack(alignment: .leading, spacing: 8) {
                // 첫 번째 행 (4개)
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { index in
                        let hashtag = viewModel.hashtags[index]
                        HashtagButton(
                            hashtagName: hashtag,
                            isSelected: viewModel.isHashtagSelected(hashtag)
                        ) {
                            viewModel.toggleHashtag(hashtag)
                        }
                    }
                }
                
                // 두 번째 행 (4개)
                HStack(spacing: 8) {
                    ForEach(4..<8, id: \.self) { index in
                        let hashtag = viewModel.hashtags[index]
                        HashtagButton(
                            hashtagName: hashtag,
                            isSelected: viewModel.isHashtagSelected(hashtag)
                        ) {
                            viewModel.toggleHashtag(hashtag)
                        }
                    }
                }
                
                // 세 번째 행 (5개)
                HStack(spacing: 8) {
                    ForEach(8..<13, id: \.self) { index in
                        let hashtag = viewModel.hashtags[index]
                        HashtagButton(
                            hashtagName: hashtag,
                            isSelected: viewModel.isHashtagSelected(hashtag)
                        ) {
                            viewModel.toggleHashtag(hashtag)
                        }
                    }
                }
            }
            
            Spacer().frame(height: 80)
            
            // 직접 추가하기 버튼
            Button(action: {
                viewModel.addCustomHashtagButtonTapped()
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
                // TODO: 다음 화면 이동 Navigation (이 작동 함수도 뷰모델에?)
            }
        }
        .padding(.horizontal, 16)
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
                .foregroundStyle(isSelected ? Color.green060 : .gray050)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isSelected ? Color.green010 : .white)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(isSelected ? Color.green060 : .gray050, lineWidth: 1)
                )
        }
    }
}

#Preview {
    HashtagSelectionView()
}
