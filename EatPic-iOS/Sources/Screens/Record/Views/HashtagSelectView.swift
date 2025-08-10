import SwiftUI

struct HashtagSelectView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewmodel: PicCardRecorViewModel
    
    @State private var availableHashtags: [String] = [
        "야식", "브런치", "혼밥", "집밥",
        "식단관리", "자취생", "건강", "맛집",
        "비건", "한식", "양식", "중식", "일식"
    ]
    @State private var selectedHashtags: Set<String> = []
    
    private let maxSelectionCount = 3

    var body: some View {
        VStack {
            // 상단 이미지
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)

            Spacer().frame(height: 36)

            // 안내 텍스트
            Text("식사와 연관된\n해시태그를 선택해주세요")
                .font(.dsTitle2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer().frame(height: 8)

            Text("최대 3개를 선택할 수 있어요")
                .font(.dsFootnote)
                .foregroundStyle(Color.gray060)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer().frame(height: 32)

            // 해시태그 버튼 영역
            VStack(spacing: 8) {
                ForEach(hashtagRows, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { hashtag in
                            let isSelected = selectedHashtags.contains(hashtag) // 현재 선택 상태
                            let isDisabled = selectedHashtags
                                .count >= maxSelectionCount && !isSelected // 최대 선택 제한
                            
                            // 해시태그 버튼
                            Button(action: {
                                toggleHashtag(hashtag) // 선택/해제 로직
                            }) {
                                Text("#\(hashtag)")
                                    .font(.dsCallout)
                                    .foregroundStyle(isSelected ? Color.green060
                                                     : .gray050) // 선택 시 글자색 변경
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(isSelected ? Color.green010
                                                : Color.white) // 선택 시 배경색 변경
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .stroke(isSelected ? Color.green060
                                                    : Color.gray050, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                            .disabled(isDisabled) // 3개 이상 선택시 나머지 비활성화
                        }
                        Spacer()
                    }
                }
                
                Spacer().frame(height: 80)

                // 직접 추가하기 버튼
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // TODO: 해시태그 추가 바텀 시트뷰 open
                    }) {
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
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
            }

            Spacer().frame(height: 51)

            // 하단 확인 버튼
            PrimaryButton(
                color: .green060,
                text: "확인",
                font: .dsTitle3,
                textColor: .white,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                // 여기서 뷰모델에 저장
                // (확인 버튼 누를 때 ViewModel의 recordModel.hashtags에 최종 반영)
                viewmodel.recordModel.hashtags = Array(selectedHashtags)
                // PicCardRecor로 Navigation
                container.router.push(.picCardRecord(
                    selectedMeal: viewmodel.recordModel.mealTime ?? .breakfast,
                    selectedHashtags: Array(selectedHashtags)
                ))
            }
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
    }
    
    // 해시태그를 4개씩 묶어 행(row) 배열로 반환
    private var hashtagRows: [[String]] {
        stride(from: 0, to: availableHashtags.count, by: 4).map {
            Array(availableHashtags[$0..<min($0+4, availableHashtags.count)])
        }
    }
    
    // 해시태그 선택/해제 토글 로직
    private func toggleHashtag(_ hashtag: String) {
        if selectedHashtags.contains(hashtag) {
            // 이미 선택 시 해제
            selectedHashtags.remove(hashtag)
        } else {
            // 미선택 & 개수 제한 미충족 시 선택
            if selectedHashtags.count < maxSelectionCount {
                selectedHashtags.insert(hashtag)
            }
        }
    }
}

#Preview {
    HashtagSelectView()
        .environmentObject(PicCardRecorViewModel())
}
