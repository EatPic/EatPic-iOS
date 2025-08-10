//
//  HashtagSelectionView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

struct HashtagSelectionView: View {
    @EnvironmentObject private var container: DIContainer
    
    let selectedMeal: MealType
    
    // 해시 태그 데이터
    let hashtags = [
        "야식", "브런치", "혼밥", "집밥",
        "식단관리", "자취생", "건강", "맛집",
        "비건", "한식", "양식", "중식", "일식"
    ]
    
    // 선택된 해시태그들
    @State private var selectedHashtags: Set<String> = []
    
    // 바텀 시트 표시 여부
    @State private var showHashtagAddSheet = false
    
    // 최대 선택 가능한 개수
    private let maxSelectionCount = 3

    // MARK: - Init
    init(selectedMeal: MealType) {
        self.selectedMeal = selectedMeal
    }

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
                .foregroundStyle(Color.gray060)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 32)

            // 해시태그 버튼들
            VStack(alignment: .leading, spacing: 8) {
                // 첫 번째 행 (4개)
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { index in
                        HashtagButton(
                            hashtagName: hashtags[index],
                            isSelected: selectedHashtags
                                .contains(hashtags[index]),
                            isDisabled: selectedHashtags
                                .count >= maxSelectionCount && !selectedHashtags
                                .contains(hashtags[index]),
                            hashtagBtnAction: {
                                toggleHashtag(hashtags[index])
                            }
                        )
                    }
                }
                
                // 두 번째 행 (4개)
                HStack(spacing: 8) {
                    ForEach(4..<8, id: \.self) { index in
                        HashtagButton(
                            hashtagName: hashtags[index],
                            isSelected: selectedHashtags
                                .contains(hashtags[index]),
                            isDisabled: selectedHashtags
                                .count >= maxSelectionCount && !selectedHashtags
                                .contains(hashtags[index]),
                            hashtagBtnAction: {
                                toggleHashtag(hashtags[index])
                            }
                        )
                    }
                }
                
                // 세 번째 행 (5개)
                HStack(spacing: 8) {
                    ForEach(8..<13, id: \.self) { index in
                        HashtagButton(
                            hashtagName: hashtags[index],
                            isSelected: selectedHashtags
                                .contains(hashtags[index]),
                            isDisabled: selectedHashtags
                                .count >= maxSelectionCount && !selectedHashtags
                                .contains(hashtags[index]),
                            hashtagBtnAction: {
                                toggleHashtag(hashtags[index])
                            }
                        )
                    }
                }
            }
            
            Spacer().frame(height: 80)
            
            // 직접 추가하기 버튼
            Button(action: {
                showHashtagAddSheet = true
            }, label: {
                HStack {
                    Text("직접 추가하기")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray060)
                    
                    Spacer()
                    
                    Image("Record/btn_record_add")
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(width: 135, height: 38)
                .background(Color.gray020)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            
            Spacer().frame(height: 51)
            
            // 최하단 버튼
            PrimaryButton(
                color: selectedHashtags.isEmpty != true ? .green060 : .gray020,
                text: "확인",
                font: .dsTitle3,
                textColor: selectedHashtags.isEmpty != true ? .white : .gray040,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                container.router.push(
.picCardRecord(
    selectedMeal: selectedMeal,
    selectedHashtags: Array(
        selectedHashtags
    )
)
                )
            }
            .disabled(
                selectedHashtags.isEmpty
            ) // selectedHashtags가 비어있을 경우 버튼 동작 비활성화
        }
        .padding(.horizontal, 16)
        .customNavigationBar {
            Text("Pic 카드 기록")
        } right: {
            Button(action: {
                container.router.popToRoot()
            }, label: {
                Image("Record/btn_home_close")
            })
        }
        .sheet(isPresented: $showHashtagAddSheet) {
            BottomSheetView(
                title: "",
                content: { HashtagAddView() }
            )
            .presentationDetents([.fraction(0.3)])
        }
    }
    
    // MARK: - Helper Functions
    
    /// 해시태그 선택/해제 토글
    private func toggleHashtag(_ hashtag: String) {
        if selectedHashtags.contains(hashtag) {
            // 이미 선택된 경우 → 해제
            selectedHashtags.remove(hashtag)
            print("해시태그 해제: \(hashtag)")
        } else {
            // 선택되지 않은 경우 → 선택 (최대 3개까지만)
            if selectedHashtags.count < maxSelectionCount {
                selectedHashtags.insert(hashtag)
                print("해시태그 선택: \(hashtag)")
            } else {
                print("최대 3개까지만 선택할 수 있습니다")
            }
        }
    }
}

// MARK: 해시태그 버튼
private struct HashtagButton: View {
    let hashtagName: String
    let isSelected: Bool
    let isDisabled: Bool
    let hashtagBtnAction: () -> Void
    
    var body: some View {
        Button(action: hashtagBtnAction) {
            Text("#\(hashtagName)")
                .font(.dsCallout)
                .foregroundStyle(isSelected ? Color.green060 : .gray050)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isSelected ? Color.green010 : .white)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .overlay(alignment: .center) {
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(
                            isSelected ? Color.green060 : .gray050,
                            lineWidth: 1
                        )
                }
        }
        .disabled(isDisabled)
    }
}

// #Preview {
//    HashtagSelectionView()
// }
