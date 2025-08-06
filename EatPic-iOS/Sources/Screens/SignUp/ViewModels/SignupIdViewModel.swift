//
//  SignupIdViewModel.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 8/1/25.
//

import Foundation

/// ID로 회원가입 ViewModel
@Observable
class SignUpIdViewModel: SignupFlowViewModel {
    
    // MARK: - Property
    
    /// 테스트용 중복 아이디 목록
    let registeredIds = ["test123", "abcde"]
    
    override var id: String {
        get { super.id }
        set { super.id = newValue }
    }
    
    // MARK: - Error Message
    
    /// 아이디 검사 에러 메시지
    var idErrorMessage: String? {
        if id.isEmpty {
            return nil
        } else if id.count < 5 {
            return "아이디는 최소 5자 이상이어야 합니다."
        } else if containsSpecialCharacters(id) {
            return "특수문자는 사용할 수 없습니다."
        } else if containsKoreanCharacters(id) {
            return "한글은 사용할 수 없습니다."
        } else if isIdDuplicate(id) {
            return "이미 사용 중인 아이디입니다."
        }
        return nil
    }
    
    // MARK: - 아이디 유효성 검사 Func
    
    /// 아이디 유효성 검사
    var isIdValid: Bool {
        return !id.isEmpty &&
        id.count >= 5 &&
        !containsSpecialCharacters(id) &&
        !containsKoreanCharacters(id) &&
        !isIdDuplicate(id)
    }
    
    /// 특수문자 포함 여부
    private func containsSpecialCharacters(_ text: String) -> Bool {
        let regex = "[~!@#$%^&*()_+=\\[\\]{}|\\\\:;\"'<>,.?/]"
        return text.range(of: regex, options: .regularExpression) != nil
    }

    /// 한글 포함 여부
    private func containsKoreanCharacters(_ text: String) -> Bool {
        let regex = "[가-힣ㄱ-ㅎㅏ-ㅣ]"
        return text.range(of: regex, options: .regularExpression) != nil
    }

    /// 중복 여부 검사
    private func isIdDuplicate(_ id: String) -> Bool {
        registeredIds.contains(id)
    }
}
