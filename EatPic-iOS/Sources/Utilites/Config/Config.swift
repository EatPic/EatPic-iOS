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
    
    static let baseURL: String = {
        guard let baseURL = Config.infoDictionary["BASE_URL"] as? String else {
            fatalError()
        }
        return baseURL
    }()
    
    static let testImageURL: String = {
        guard let testImageURL = Config.infoDictionary["TEST_IMG_URL"] as? String else {
            fatalError()
        }
        return testImageURL
    }()
    
static let appVersion: String = {
    guard let appVersion = Config.infoDictionary["APP_VERSION"] as? String else {
        fatalError("APP_VERSION not set in Info.plist")
    }
    return appVersion
}()

static let appBuild: String = {
    guard let appBuild = Config.infoDictionary["APP_BUILD"] as? String else {
        fatalError("APP_BUILD not set in Info.plist")
    }
    return appBuild
}()
}
