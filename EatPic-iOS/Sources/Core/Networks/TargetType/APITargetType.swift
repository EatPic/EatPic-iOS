//
//  APITargetType.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/17/25.
//

import Foundation
import Moya

protocol APITargetType: TargetType {}

extension APITargetType {
    var baseURL: URL {
        // TODO: 추후 실제 URL로 변경 필요
        guard let url = URL(string: Config.baseURL) else {
            fatalError("Invalid baseURL")
        }
        return url
    }
    
    var headers: [String: String]? {
        switch task {
        case .requestJSONEncodable, .requestParameters:
            return ["Content-Type": "application/json"]
        case .uploadMultipart:
            return ["Content-Type": "multipart/form-data"]
        default:
            return nil
        }
    }
    
    /// `.successCodes`를 반환하여 Moya는 서버 응답증 200대 응답 코드만을 유효한 응답으로 간주하고 나머지는 실패로 처리합니다.
    /// retry가 실행되기 위한 조건으로 200대 응답만을 유효한 응답으로 간주하도록 설정하는 것입니다.
    var validationType: ValidationType { .successCodes }
    
    var sampleData: Data {
        switch self {
        default:
            return Data("{\"message\": \"Hello, world!\"}".utf8)
        }
    }
}
