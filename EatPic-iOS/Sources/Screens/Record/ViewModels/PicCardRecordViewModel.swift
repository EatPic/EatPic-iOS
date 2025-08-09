//
//  PicCardRecordViewModel.swift
//  EatPic-iOS
//
//  Created by AI Assistant on 8/7/25.
//

import SwiftUI
import Combine
import Foundation

@MainActor
final class PicCardRecordViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Pic 카드 기록 모델
    @Published var picCardRecord: PicCardRecordModel
    
    /// 현재 상태
    @Published var state: PicCardRecordState = .idle
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(selectedMeal: MealType, selectedHashtags: [String]) {
        self.picCardRecord = PicCardRecordModel(
            selectedMeal: selectedMeal,
            selectedHashtags: selectedHashtags
        )
    }
    
    // MARK: - Public Methods
    
    /// Pic 카드 저장
    /// - Parameters:
    ///   - myMemo: 사용자 메모
    ///   - receiptDetail: 레시피 내용
    ///   - isSharedToFeed: 피드 공유 여부
    func savePicCard(myMemo: String, receiptDetail: String, isSharedToFeed: Bool) {
        state = .saving
        
        // 현재 날짜와 시간 설정
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        // 날짜 포맷 (년, 월, 일)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let savedDate = dateFormatter.string(from: currentDate)
        
        // 시간 포맷 (시간, 분)
        dateFormatter.dateFormat = "HH:mm"
        let savedTime = dateFormatter.string(from: currentDate)
        
        // 모델 업데이트
        picCardRecord.myMemo = myMemo
        picCardRecord.receiptDetail = receiptDetail
        picCardRecord.isSharedToFeed = isSharedToFeed
        picCardRecord.savedDate = savedDate
        picCardRecord.savedTime = savedTime
        
        // 디버그 로그
        printSaveInfo()
        
        // TODO: [25.08.07] 실제 데이터 저장 로직 구현 - 비엔/이은정
        // 현재는 즉시 저장 완료로 처리 (실제 API 호출 시 비동기 처리 필요)
        completeSave()
    }
    
    /// 저장 완료 처리
    private func completeSave() {
        state = .saved
        print("🎉 Pic 카드 저장 완료! state = .saved")
    }
    
    /// 저장 실패 처리
    /// - Parameter errorMessage: 에러 메시지
    func handleSaveError(_ errorMessage: String) {
        state = .error(errorMessage)
        print("Pic 카드 저장 실패: \(errorMessage)")
    }
    
    /// 상태 초기화
    func resetState() {
        state = .idle
    }
    
    // MARK: - Private Methods
    
    /// 저장 정보 출력 (디버그용)
    private func printSaveInfo() {
        print("Pic 카드 저장:")
        print("- 저장 날짜: \(picCardRecord.savedDate)")
        print("- 저장 시간: \(picCardRecord.savedTime)")
        print("- 선택된 식사 시간: \(picCardRecord.selectedMeal.rawValue)")
        print("- 선택된 해시태그: \(picCardRecord.selectedHashtags)")
        print("- 나의 메모: \(picCardRecord.myMemo)")
        print("- 레시피 내용: \(picCardRecord.receiptDetail)")
        print("- 피드 공유 여부: \(picCardRecord.isSharedToFeed)")
    }
}

// MARK: - Computed Properties Extension

extension PicCardRecordViewModel {
    
    /// 저장 중인지 여부
    var isSaving: Bool {
        if case .saving = state {
            return true
        }
        return false
    }
    
    /// 저장 완료 여부
    var isSaved: Bool {
        if case .saved = state {
            return true
        }
        return false
    }
    
    /// 에러 발생 여부
    var hasError: Bool {
        if case .error = state {
            return true
        }
        return false
    }
    
    /// 에러 메시지
    var errorMessage: String? {
        if case .error(let message) = state {
            return message
        }
        return nil
    }
}
