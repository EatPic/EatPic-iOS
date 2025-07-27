//
//  BadgeGridModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//

import Foundation
import SwiftUI

// MARK: - Badge Data Model
struct BadgeData {
    let id: String
    let name: String
    let icon: Image
    let progress: Int // 0-10
    let isLocked: Bool
    
    init(id: String, name: String, icon: Image, progress: Int = 0) {
        self.id = id
        self.name = name
        self.icon = icon
        self.progress = progress
        self.isLocked = progress == 0
    }
    
    var progressValue: CGFloat {
        return CGFloat(progress) / 10.0
    }
    
    var badgeState: BadgeState {
        if isLocked {
            return .locked
        } else {
            return .progress(progress: progressValue, icon: icon)
        }
    }
} 
