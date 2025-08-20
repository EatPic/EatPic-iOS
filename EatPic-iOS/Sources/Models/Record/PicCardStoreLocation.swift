//
//  PicCardStoreLocation.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/20/25.
//

import Foundation

/// 가게 위치 값 오브젝트
struct PicCardStoreLocation: Equatable, Sendable {
    var name: String
    var latitude: Double?
    var longitude: Double?
    var hasCoordinate: Bool {
        latitude != nil && longitude != nil
    }
}
