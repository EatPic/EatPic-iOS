//
//  Config.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/10/25.
//

import Foundation

enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist 없음")
        }
        return dict
    }()
}
