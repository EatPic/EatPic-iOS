//
//  ToastViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/21/25.
//

import Observation
import Dispatch
import Foundation

/// `@Observable`을 통해 View에서 상태를 자동 감지하도록 설정된 ViewModel입니다.
@Observable
class ToastViewModel {
    
    // MARK: - Property
    
    /// 현재 화면에 표시될 토스트 정보 (title, duration 포함)
    var toast: ToastModel? = nil
    
    /// 토스트 자동 닫기 예약을 위한 작업 객체
    private var dismissWorkItem: DispatchWorkItem?
    
    // MARK: - Function
    
    /// 새로운 토스트를 화면에 띄우는 메서드
    /// - Parameters:
    ///   - title: 보여줄 토스트 메시지
    ///   - duration: 토스트가 화면에 유지될 시간 (초 단위)
    func showToast(title: String, duration: TimeInterval = 2.0) {
        // 현재 토스트 상태를 설정하여 화면에 표시되도록 트리거
        toast = ToastModel(title: title, duration: duration)
        
        // 기존 예약된 작업이 있으면 취소 (중복 실행 방지)
        dismissWorkItem?.cancel()
        
        // 새로운 작업을 정의 (토스트 작업 시작점)
        // - 이 작업은 일정 시간이 지난 후에 'toast = nil'을 실행하여 토스트 닫음
        let task = DispatchWorkItem { [weak self] in
            self?.dismissToast()
        }
        
        // 지금 생성한 닫기 작업(task)을 저장
        dismissWorkItem = task
        
        // 일정시간 후('duration = 2.0')에 위에서 만든 작업(task) 실행하도록 예약
        DispatchQueue.main
            .asyncAfter(deadline: .now() + duration, execute: task)
    }
    
    /// 현재 토스트뷰 즉시 닫음
    func dismissToast() {
        // 상태값을 nil로 변경하여 화면에서 토스트 제거
        toast = nil
        
        // 예약된 작업이 있다면 취소하고 해제
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
    }
}
