//
//  HomeTargetType.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/9/25.
//

import Foundation
import Moya

enum HomeTargetType {
    case fetchCalendar(year: Int, month: Int)
    case greetingMessage
    case badgeList
    case badgeDetail(userBadgeID: Int)
}

extension HomeTargetType: APITargetType {
    var path: String {
        switch self {
        case .fetchCalendar:
            return "/api/calendar"
        case .greetingMessage:
            return "/api/greeting"
        case .badgeList:
            return "/api/badges/home"
        case .badgeDetail(let userBadgeID):
            return "/api/badges/my/\(userBadgeID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchCalendar, .greetingMessage, .badgeList, .badgeDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchCalendar(let year, let month):
            let parameters = ["year": year, "month": month]
            return .requestParameters(
                parameters: parameters, encoding: URLEncoding.queryString)
        case .greetingMessage, .badgeList, .badgeDetail:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchCalendar:
            return Data("""
             {
               "isSuccess": true,
               "code": "string",
               "message": "string",
               "result": [
                 {
                   "date": "2025-08-02",
                   "imageUrl": "https://example.com/image.jpg",
                   "cardId": 123
                 }
               ]
             }
            """.utf8)
        case .greetingMessage, .badgeList, .badgeDetail:
            return Data("""
            
            """.utf8)
        }
    }
}
