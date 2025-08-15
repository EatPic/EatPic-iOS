//
//  HashtagTitlePolicy.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/14/25.
//

import Foundation

/// 해시태그 추가 관련 정책 프로토콜
protocol HashtagTitlePolicy {
    // 타이틀이 허용되는지 검증( 성공: ok, 실패: 에러 반환)
    func validate(_ title: String) -> Result<Void, HashtagPolicyError>
    
    var maxHangul: Int { get }
}
