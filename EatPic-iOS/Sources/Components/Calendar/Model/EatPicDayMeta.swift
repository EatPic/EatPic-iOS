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
///   - URL: 해당 날짜에 연결된 이미지 URL
///   - cardID: 셀에 표시될 cardId 
struct EatPicDayMeta: Hashable, Sendable {
    let imageURL: String?
    let cardId: Int?
}

extension EatPicDayMeta {
    //// 날짜별 더미 이미지 메타 (프리뷰/개발용)
    /// - Returns: startOfDay(Date) → EatPicDayMeta 매핑
    static var dummyByDate: [Date: EatPicDayMeta] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
//        let tomorrow = cal.date(byAdding: .day, value: 1, to: today)

        // 작은 썸네일 테스트용 URL (네트워크/디코딩 가벼움)
        return [
            today: EatPicDayMeta(imageURL: "https://picsum.photos/seed/eatpic1/200", cardId: 1)
//            tomorrow: EatPicDayMeta(imageURL: "https://picsum.photos/seed/eatpic2/200", cardId: 2)
        ]
    }
}
