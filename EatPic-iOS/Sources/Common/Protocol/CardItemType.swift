//
//  CardItemType.swift
//  EatPic-iOS
//
//  Created by 원주연 on 7/19/25.
//

import Foundation
import SwiftUI

protocol CardItemType {
    var icon: Image { get }
    var count: Int? { get }
}
