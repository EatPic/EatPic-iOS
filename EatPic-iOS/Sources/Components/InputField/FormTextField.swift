//
//  FormTextField.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import SwiftUI

/// 다양한 FormFieldType에 대응 가능한 재사용 가능한 커스텀 텍스트 필드 컴포넌트 (로그인, 회원가입 등 다른 뷰에서도 사용 가능)
/// 텍스트 입력 전 placeholder가 나타나며 입력 시 사라짐
/// 포커스 상태에 따라 테두리 색상이 변경되며(focus시 green), `isSecure` 여부에 따라 `TextField` 또는 `SecureField`로 렌더링
/// - Parameters:
///   - fieldType: 텍스트 필드의 속성 정보(placeholder, title, 색상, 폰트, 키보드 타입 등)를 담고 있는 열거형
///   - focusedField: 외부에서 관리하는 포커스 상태. `FocusState<T?>`를 바인딩하여 전달
///   - currentField: 현재 이 텍스트 필드가 담당하는 필드 타입. 포커스 비교 기준으로 사용
///   - text: 바인딩된 텍스트 값으로, 입력한 문자열이 연결된 ViewModel 등 전달
///   자세한 사용 예시 및 관련 문서는 Notion '공용컴포넌트' 참고
struct FormTextField<T: FormFieldType & Hashable>: View {
    
    // MARK: - Property
    
    /// 텍스트 입력필드 상단 타이틀
    let fieldTitle: String?
    
    /// 현재 필드 타입 (예: .email, password, nickname)
    let fieldType: T
    
    /// 외부에서 제어하는 포커스 상태
    let focusedField: FocusState<T?>.Binding
    
    /// 현재 뷰에 해당하는 필드 (포커스 비교용)
    let currentField: T
    
    /// 텍스트 입력 바인딩
    @Binding var text: String
    
    /// 유효성 검사 통과 여부 변수
    let isValid: Bool
    
    // MARK: - Init
    
    /// 초기화 함수 (Binding 타입을 @Binding 변수로 연결)
    init(
        fieldTitle: String? = nil,
        fieldType: T,
        focusedField: FocusState<T?>.Binding,
        currentField: T,
        text: Binding<String>,
        isValid: Bool
    ) {
        self.fieldTitle = fieldTitle
        self.fieldType = fieldType
        self.focusedField = focusedField
        self.currentField = currentField
        self._text = text
        self.isValid = isValid
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: FormTextFieldConstants.stackSpacing) {
            /// 텍스트 필드 상단 타이틀
            if let title = fieldTitle {
                Text(title)
                    .font(fieldType.titleFont)
                    .foregroundStyle(fieldType.titleTextColor)
            }
            
            /// 텍스트 필드 속성 지정
            ZStack(alignment: .leading) {
                if text.isEmpty { // text 입력이 안되었을시
                    Text(fieldType.placeholder)
                        .font(fieldType.placeholderFont) // fieldTpye내부에서 속성 지정
                        .foregroundStyle(fieldType.placeholderTextColor)
                        .padding(.horizontal, 16)
                }
                
                HStack {
                    Group {
                        if fieldType.isSecure {
                            SecureField("", text: $text)
                                .focused(focusedField, equals: currentField)
                                .submitLabel(fieldType.submitLabel) // 키보드 리턴 버튼 타입
                        } else {
                            TextField("", text: $text)
                                .focused(focusedField, equals: currentField)
                                .keyboardType(fieldType.keyboardType) // 키보드 타입
                                .submitLabel(fieldType.submitLabel)
                        }
                    }
                    .padding(.horizontal, 16) // 텍스트 필드 패딩 설정
                    .padding(.vertical, 14)
                    
                    Spacer()
                    
                    // 텍스트가 있으면 x 버튼, 유효성 통과 시 check 아이콘
                    if !text.isEmpty {
                        if isValid {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.green060)
                                .padding(.trailing, 14)
                        } else {
                            Button(action: { text = "" }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundStyle(Color.gray050)
                            }
                            .padding(.trailing, 14)
                        }
                    }
                } //: 텍스트 필드 HStack
            } //: ZStack
            .background(alignment: .center) {
                RoundedRectangle(
                    cornerRadius: FormTextFieldConstants.cornerRadiusDegree)
                .stroke(borderColor,
                        lineWidth: FormTextFieldConstants.rectangleLinewidth)
            }
            .frame(
                height: FormTextFieldConstants.rectangleHeight
            ) // ZStack 높이: 직사각형 + 텍스트
        } //: VStack
    }
    
    /// 포커스된 필드에 따른 박스 테두리 배경색 설정
    private var borderColor: Color {
        if !isValid && !text.isEmpty {
            return .pink070
        }
        return focusedField.wrappedValue == currentField ? Color.green060 : Color.gray040
    }
}

/// FormTextField 내부에서 사용하는 상수 정의용 enum
private enum FormTextFieldConstants {
    // VStack 간격
    static let stackSpacing: CGFloat = 8
    // RoudedRectangle 높이
    static let rectangleHeight: CGFloat = 48
    // RoudedRectangle 테두리 둥근 정도
    static let cornerRadiusDegree: CGFloat  = 10
    // RoudedRectangle 테두리 두께
    static let rectangleLinewidth: CGFloat = 1
}
