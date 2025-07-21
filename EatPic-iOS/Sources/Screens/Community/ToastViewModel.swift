//
//  ToastViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/21/25.
//

import Observation
import Dispatch
import Foundation

/// @Observable: View에서 상태 변화 감지 기능
@Observable
class ToastViewModel {
    
    // MARK: - Property
    var toast: ToastModel? = nil
    
    private var dismissWorkItem: DispatchWorkItem?
    
    // MARK: - Function
    
    /// 토스트 표시 메서드
    func showToast(title: String, duration: TimeInterval = 2.0) {
        toast = ToastModel(title: title, duration: duration)
        dismissWorkItem?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.dismissToast()
        }
        dismissWorkItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
    
    /// 현재 토스트뷰 즉시 닫음
    func dismissToast() {
        toast = nil
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
    }
}
