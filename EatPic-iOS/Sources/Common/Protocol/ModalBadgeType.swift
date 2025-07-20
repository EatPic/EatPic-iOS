//
//  ModalBadgeType.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/19/25.
//
import SwiftUI

protocol ModalBadgeTypeProtocol {
    var badgeView: AnyView { get }
    var buttonColor: Color { get }
    var buttonBorderColor: Color { get }
    var buttonTextColor: Color { get }
    var progressText: String { get }
}
