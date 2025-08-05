//
//  SignupNicknameViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/1/25.
//

import Foundation

/// 닉네임으로 회원가입 ViewModel
@Observable
class SignUpNicknameViewModel {
    
    // MARK: - Property
    
    /// 이미 등록된 닉네임 테스트용 데이터
    let registeredNicknames = ["홍길동", "김철수"]

    /// 사용자 입력 닉네임
    var nickname: String = ""
    
    // MARK: - Error Message
    
    /// 닉네임 유효성 검사 결과 메시지
    var nicknameErrorMessage: String? {
        if nickname.isEmpty {
            return nil
        } else if nickname.count < 2 {
            return "닉네임은 2자 이상이어야 합니다."
        } else if containsSpecialCharacters(nickname) {
            return "특수문자를 사용할 수 없습니다."
        } else if containsEnglishLetters(nickname) {
            return "영문은 사용할 수 없습니다."
        } else if containsDigits(nickname) {
            return "닉네임에 숫자를 사용할 수 없습니다."
        } else if isNicknameDuplicate(nickname) {
            return "이미 사용중인 닉네임입니다."
        } else {
            return nil
        }
    }
    
    // MARK: - 닉네임 유효성 검사 Func
    
    /// 닉네임 유효성 검사
    var isNicknameValid: Bool {
        return !nickname.isEmpty &&
        nickname.count >= 2 &&
        !containsSpecialCharacters(nickname) &&
        !containsEnglishLetters(nickname) &&
        !containsDigits(nickname) &&
        !isNicknameDuplicate(nickname)
    }
    
    /// 특수문자 포함 여부
    private func containsSpecialCharacters(_ text: String) -> Bool {
        let regex = "[~!@#$%^&*()_+=\\[\\]{}|\\\\;:'\",.<>/?`]"
        return text.range(of: regex, options: .regularExpression) != nil
    }
    
    /// 영문 사용 여부
    private func containsEnglishLetters(_ text: String) -> Bool {
        let regex = "[A-Za-z]"
        return text.range(of: regex, options: .regularExpression) != nil
    }
    
    /// 숫자포함 여부
    private func containsDigits(_ text: String) -> Bool {
        let regex = "[0-9]"
        return text.range(of: regex, options: .regularExpression) != nil
    }
    
    /// 닉네임 중복 여부
    private func isNicknameDuplicate(_ nickname: String) -> Bool {
        registeredNicknames.contains(nickname)
    }
}
