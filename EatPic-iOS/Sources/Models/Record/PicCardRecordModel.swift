import Foundation

/// Pic 카드 기록 데이터를 담는 모델
struct PicCardRecordModel {
    /// 사용자가 입력한 메모
    var myMemo: String
    
    /// 레시피 내용
    var receiptDetail: String
    
    /// 피드 공유 여부
    var isSharedToFeed: Bool
    
    /// 선택된 식사 타입
    var selectedMeal: MealType
    
    /// 선택된 해시태그들
    var selectedHashtags: [String]
    
    /// 저장된 날짜
    var savedDate: String
    
    /// 저장된 시간
    var savedTime: String
    
    /// 이니셜라이저
    init(
        myMemo: String = "",
        receiptDetail: String = "",
        isSharedToFeed: Bool = false,
        selectedMeal: MealType,
        selectedHashtags: [String],
        savedDate: String = "",
        savedTime: String = ""
    ) {
        self.myMemo = myMemo
        self.receiptDetail = receiptDetail
        self.isSharedToFeed = isSharedToFeed
        self.selectedMeal = selectedMeal
        self.selectedHashtags = selectedHashtags
        self.savedDate = savedDate
        self.savedTime = savedTime
    }
}

/// Pic 카드 기록 상태를 나타내는 열거형
enum PicCardRecordState: Equatable {
    case idle
    case saving
    case saved
    case error(String)
}
