//
//  EatPicDayMeta.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import SwiftUI

/// 캘린더 셀에 표시할 이미지 데이터를 포함하는 메타 정보 구조체입니다.
///
/// - Parameters:
///   - img: 해당 날짜에 연결된 이미지. 없을 수도 있습니다.
struct EatPicDayMeta {
    var img: Image?
}

extension EatPicDayMeta {
    /// 날짜별 더미 이미지 메타 정보를 제공합니다.
    ///
    /// 오늘 날짜와 그 다음 날에 대해 `EatPicDayMeta`를 포함하는 임시 데이터를 반환합니다.
    /// API 연동 전까지 셀에 이미지를 렌더링할 목적으로 사용됩니다.
    ///
    /// - Returns: `Date`를 키로 하고, 해당 날짜의 `EatPicDayMeta`를 값으로 갖는 딕셔너리
    static var dummyByDate: [Date: EatPicDayMeta] {
        let calendar = Calendar.current
        var result: [Date: EatPicDayMeta] = [:]

        // 예시: 오늘과 오늘 + 1일 뒤에 이미지 존재
        let today = calendar.startOfDay(for: Date())
        
        if let future = calendar.date(byAdding: .day, value: 1, to: today) {
            result[today] = EatPicDayMeta(img: Image(.Calendar.img))
            result[future] = EatPicDayMeta(img: Image(.Calendar.img))
        }

        return result
    }
}
