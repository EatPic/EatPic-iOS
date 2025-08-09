//
//  HashtagSelectionView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

/// 식사와 관련된 해시태그를 선택하는 화면
/// 사용자가 선택한 식사 타입에 맞는 해시태그를 최대 3개까지 선택할 수 있음
struct HashtagSelectionView: View {
    /// 의존성 주입 컨테이너 (네비게이션 라우터 등 포함)
    @EnvironmentObject private var container: DIContainer
    
    /// 이전 화면에서 선택된 식사 타입 (아침, 점심, 저녁, 간식)
    let selectedMeal: MealType
    
    // MARK: - State Properties
    
    /// 선택 가능한 해시태그 목록 (기본 해시태그 + 사용자가 추가한 해시태그)
    @State private var availableHashtags: [String] = [
        "야식", "브런치", "혼밥", "집밥",
        "식단관리", "자취생", "건강", "맛집",
        "비건", "한식", "양식", "중식", "일식"
    ]
    
    /// 사용자가 선택한 해시태그들 (Set을 사용하여 중복 방지)
    @State private var selectedHashtags: Set<String> = []
    
    /// 해시태그 추가 바텀시트 표시 여부
    @State private var showHashtagAddSheet = false
    
    /// 새로운 해시태그 입력값 (사용자가 직접 추가할 때 사용)
    @State private var newHashtagInput = ""
    
    // MARK: - Constants
    
    /// 최대 선택 가능한 해시태그 개수
    private let maxSelectionCount = 3
    
    /// 새로 추가할 해시태그의 최대 글자수
    private let maxHashtagLength = 5

    // MARK: - Init
    
    /// 이니셜라이저
    /// - Parameter selectedMeal: 이전 화면에서 선택된 식사 타입
    init(selectedMeal: MealType) {
        self.selectedMeal = selectedMeal
    }
    
    // MARK: - Computed Properties
    
    /// 해시태그를 4개씩 나누어 행으로 구성하는 2차원 배열
    /// UI에서 해시태그들을 격자 형태로 표시하기 위해 사용
    private var hashtagRows: [[String]] {
        var rows: [[String]] = []
        
        // 4개씩 나누어 행 생성
        for startIndex in stride(from: 0, to: availableHashtags.count, by: 4) {
            let endIndex = min(startIndex + 4, availableHashtags.count)
            let row = Array(availableHashtags[startIndex..<endIndex])
            rows.append(row)
        }
        
        return rows
    }
    
    /// 확인 버튼 활성화 여부
    /// 최소 1개 이상의 해시태그가 선택되어야 활성화
    private var isConfirmButtonEnabled: Bool {
        !selectedHashtags.isEmpty
    }
    
    /// 새 해시태그 추가 버튼 활성화 여부
    /// 입력값이 비어있지 않고, 최대 글자수 이하이며, 중복되지 않아야 활성화
    private var isAddButtonEnabled: Bool {
        !newHashtagInput.isEmpty && 
        newHashtagInput.count <= maxHashtagLength &&
        !availableHashtags.contains(newHashtagInput.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    // MARK: - Body
    
    var body: some View {
        VStack {
            // MARK: - 상단 캐릭터 이미지
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)
            
            Spacer().frame(height: 36)
            
            //  MARK: - 텍스트
            Text("식사와 연관된\n해시태그를 선택해주세요")
                .font(.dsTitle2)
                .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
            
            Spacer().frame(height: 8)
            
            Text("최대 3개를 선택할 수 있어요")
                .font(.dsFootnote)
                .foregroundStyle(Color.gray060)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 32)
            
            // MARK: - 해시태그 선택 영역
            VStack(spacing: 8) {
                // 해시태그 버튼들을 행별로 표시
                ForEach(hashtagRows, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { hashtag in
                            hashtagButton(for: hashtag)
                        }
                        Spacer() // 왼쪽 정렬을 위한 Spacer
                    }
                }
                
                // MARK: - 직접 추가하기 버튼
                HStack {
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
                    
                    Spacer() // 왼쪽 정렬을 위한 Spacer
                }
            }
            
            Spacer().frame(height: 80) // 원본과 동일한 간격
            
            Spacer().frame(height: 51) // 원본 간격
            
            // MARK: - 하단 확인 버튼 (PrimaryButton 사용)
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
                        selectedHashtags: Array(selectedHashtags)
                    )
                )
            }
            .disabled(selectedHashtags.isEmpty) // 선택된 해시태그가 없으면 비활성화
        }
        .padding(.horizontal, 16) // 좌우 여백
        // MARK: - 네비게이션 바 설정
        .customNavigationBar {
            Text("Pic 카드 기록")
        } right: {
            // 홈으로 이동하는 닫기 버튼
            Button(action: {
                container.router.popToRoot()
            }, label: {
                Image("Record/btn_home_close")
            })
        }
        // MARK: - 해시태그 추가 바텀시트
        .sheet(isPresented: $showHashtagAddSheet) {
            HashtagAddView(
                hashtagInput: $newHashtagInput,
                isAddButtonEnabled: isAddButtonEnabled,
                onAddHashtag: addNewHashtag,
                onClose: hideAddHashtagSheet
            )
        }
    }
    
    // MARK: - Private Methods
    
    /// 개별 해시태그 버튼을 생성하는 메서드
    /// - Parameter hashtag: 표시할 해시태그 텍스트
    /// - Returns: 해시태그 버튼 View
    @ViewBuilder
    private func hashtagButton(for hashtag: String) -> some View {
        let isSelected = selectedHashtags.contains(hashtag)
        let isDisabled = selectedHashtags.count >= maxSelectionCount && !isSelected
        
        Button(action: {
            toggleHashtag(hashtag)
        }) {
            Text("#\(hashtag)")
                .font(.dsCallout)
                .foregroundStyle(isSelected ? Color.green060 : .gray050)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isSelected ? Color.green010 : .white) // 선택 시 연한 그린, 기본 흰색
                .clipShape(RoundedRectangle(cornerRadius: 50)) // 완전히 둥근 모서리
                .overlay(alignment: .center) {
                    // 테두리: 선택 시 그린, 기본 회색
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(
                            isSelected ? Color.green060 : .gray050,
                            lineWidth: 1
                        )
                }
        }
        .disabled(isDisabled) // 최대 개수 초과 시 비활성화
    }
    
    /// 해시태그 선택/해제를 토글하는 메서드
    /// - Parameter hashtag: 토글할 해시태그
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
                print("최대 \(maxSelectionCount)개까지만 선택할 수 있습니다")
            }
        }
    }
    
    /// 사용자가 입력한 새로운 해시태그를 추가하는 메서드
    /// 유효성 검사를 거쳐 중복되지 않고 올바른 길이의 해시태그만 추가
    private func addNewHashtag() {
        let trimmedHashtag = newHashtagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 유효성 검사: 비어있지 않고, 최대 글자수 이하이며, 중복되지 않아야 함
        guard !trimmedHashtag.isEmpty,
              trimmedHashtag.count <= maxHashtagLength,
              !availableHashtags.contains(trimmedHashtag) else {
            print("해시태그 추가 실패: 유효하지 않은 해시태그")
            return
        }
        
        // 해시태그를 목록에 추가
        availableHashtags.append(trimmedHashtag)
        print("새 해시태그 추가: \(trimmedHashtag)")
        
        // 입력값 초기화 및 바텀시트 닫기
        newHashtagInput = ""
        showHashtagAddSheet = false
    }
    
    /// 해시태그 추가 바텀시트를 닫고 입력값을 초기화하는 메서드
    private func hideAddHashtagSheet() {
        showHashtagAddSheet = false
        newHashtagInput = ""
    }
}

// #Preview {
//    HashtagSelectionView(selectedMeal: .lunch)
// }
