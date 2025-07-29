//
//  HashtagSelectModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation

// MARK: - 해시태그 데이터 모델
struct HashtagData: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
} 
