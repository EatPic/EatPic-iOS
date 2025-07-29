//
//  HashtagViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/29/25.
//


import Foundation

// MARK: - 해시태그 데이터 모델
struct HashtagModel: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    
    init(
        name: String
    ) {
        self.name = name
    }
}



import SwiftUI

// MARK: - 해시태그 버튼 상태 enum
enum HashtagButtonState {
    case selected
    case unselected
}

extension HashtagButtonState {
    var backgroundColor: Color {
        switch self {
        case .selected: return .green010
        case .unselected: return .white
        }
    }

    var textColor: Color {
        switch self {
        case .selected: return .green060
        case .unselected: return .gray050
        }
    }

    var borderColor: Color {
        switch self {
        case .selected: return .green060
        case .unselected: return .gray050
        }
    }
}
