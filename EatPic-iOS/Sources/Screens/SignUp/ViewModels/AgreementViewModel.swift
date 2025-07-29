//
//  AgreementViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/29/25.
//

import Foundation

/// 약관동의 리스트 뷰모델 정의
@Observable
class AgreementViewModel {
    var agreementList: [AgreementItem] = [
        AgreementItem(title: "이용약관 동의 (필수)", isRequired: true, isChecked: false, type: .service),
        AgreementItem(title: "개인정보처리방침 동의 (필수)", isRequired: true, isChecked: false, type: .privacy),
                AgreementItem(title: "마케팅 정보 수신 동의 (선택)", isRequired: false, isChecked: false, type: .marketing)
    ]
    
    /// 체크 표시 토글
    func toggleAgreement(at index: Int) {
        agreementList[index].isChecked.toggle()
    }
    
    
    /// 전체 동의 기능
    func checkAll(_ isChecked: Bool) {
        for index in agreementList.indices {
            agreementList[index].isChecked = isChecked
        }
    }
}
