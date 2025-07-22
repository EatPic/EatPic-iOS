//
//  ToastModifier.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/21/25.
//

import Foundation
import SwiftUI

/// View에 '.toastView(viewModel:)'로 붙일 수 있는 공용 토스트 Modifier입니다.
/// MVVM 구조에서 ViewModel로부터 상태(토스트 메시지)를 받아 View에 바인딩합니다.
struct ToastModifier: ViewModifier {
    /// 바인딩 가능한 ViewModel 주입하여 상태 변화를 감지
    @Bindable var viewModel: ToastViewModel
    
    /// Modifier가 적용된 View의 실제 렌더링 구성
    func body(content: Content) -> some View {
        ZStack {
            // 기존 콘텐츠 유지
            content
            
            // ViewModel의 toast 값이 존재하면 토스트 표시
            if let toast = viewModel.toast {
                VStack {
                    // 하단 정렬
                    Spacer()
                    
                    // 공용 토스트 view 사용
                    ToastView(title: toast.title)
                }
                .transition(.opacity) // fade in/out 애니메이션
                .animation(.easeInOut(duration: 0.3), value: toast) // fade 애니메이션 효과
                .padding(.bottom, 20)
            }
        }
    }
}

/// 뷰에 .toastView(toast: $toast)를 붙이면 자동으로 ToastModifier가 적용됨
extension View {
    /// 공용 토스트 뷰를 View에 부착
    func toastView(viewModel: ToastViewModel) -> some View {
        self.modifier(ToastModifier(viewModel: viewModel))
    }
}
