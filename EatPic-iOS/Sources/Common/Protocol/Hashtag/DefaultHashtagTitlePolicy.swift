//
//  DefaultHashtagTitlePolicy.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/14/25.
//

import Foundation

struct DefaultHashtagTitlePolicy: HashtagTitlePolicy {
    let maxHangul: Int = 5
    
    func validate(_ title: String) -> Result<Void, HashtagPolicyError> {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return .failure(.empty) }
        
        let length = trimmed.count
        
        return length <= maxHangul ? .success(()) : .failure(.tooLongHangul(limit: maxHangul))
    }
}
