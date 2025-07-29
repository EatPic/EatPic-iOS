//
//  AgreementItem.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/29/25.
//

import Foundation

/// 회원가입 약관동의 리스트 뷰 모델 정의
struct AgreementItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let isRequired: Bool // 약관동의 (필수/선택)
    let isChecked: Bool
    let type: AgreementType // 약관 동의 타입
}

enum AgreementType: Hashable {
    case service // 이용약관 동의
    case privacy // 개인정보처리 동의
    case marketing // 마케팅 정보 수신 동의
}
