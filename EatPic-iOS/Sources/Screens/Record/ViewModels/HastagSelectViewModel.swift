//
//  HashtagSelectViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

/// 해시태그 선택 화면의 ViewModel
class HashtagSelectViewModel: ObservableObject {
    
    // MARK: - Property
    
    /// 선택된 해시태그들
    @Published var selectedHashtags: Set<String> = []
    
    /// 해시태그 목록
    let hashtags = [
        "야식", "브런치", "혼밥", "집밥",
        "식단관리", "자취생", "건강", "맛집",
        "비건", "한식", "양식", "중식", "일식"
    ]
    
    // MARK: - Computed Properties
    
    /// 선택된 해시태그 개수
    var selectedCount: Int {
        return selectedHashtags.count
    }
    
    /// 최대 선택 가능한 개수
    let maxSelectionCount = 3
    
    /// 더 선택할 수 있는지 여부
    var canSelectMore: Bool {
        return selectedCount < maxSelectionCount
    }
    
    // MARK: - Methods
    
    /// 해시태그 선택/해제 토글
    func toggleHashtag(_ hashtag: String) {
        if selectedHashtags.contains(hashtag) {
            // 이미 선택된 경우 -> 해제
            selectedHashtags.remove(hashtag)
            print("해시태그 해제: \(hashtag)")
        } else {
            // 선택되지 않은 경우 -> 선택 (최대 3개까지만)
            if canSelectMore {
                selectedHashtags.insert(hashtag)
                print("해시태그 선택: \(hashtag)")
            } else {
                print("최대 3개까지만 선택할 수 있습니다")
            }
        }
    }
    
    /// 해시태그가 선택되었는지 확인
    func isHashtagSelected(_ hashtag: String) -> Bool {
        return selectedHashtags.contains(hashtag)
    }
    
    /// 직접 추가하기 버튼 액션
    func addCustomHashtagButtonTapped() {
        print("직접 추가하기 버튼 클릭")
        // TODO: BottomSheetView 띄우기
    }
}
