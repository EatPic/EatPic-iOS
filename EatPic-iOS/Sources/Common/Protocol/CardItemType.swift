//
//  CardItemType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/19/25.
//

import Foundation
import SwiftUI

/// 공통 인터페이스: 아이콘과 카운트를 표시하는 항목 타입 정의
protocol CardItemType {
    var icon: Image { get }
    var count: Int? { get }
}
