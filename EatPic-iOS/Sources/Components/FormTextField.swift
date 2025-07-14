//
//  FormTextField.swift
//  EatPic-iOS
//
//  Created by 송승윤 on 7/14/25.
//

import SwiftUI

struct FormTextField<T: FormFieldType & Hashable>: View {
    
    // MARK: - Property
    
    /// 현재 필드 타입 (예: .email, password, nickname)
    let fieldType: T
    
    /// 외부에서 제어하는 포커스 상태
    let focusedField: FocusState<T?>.Binding
    
    /// 현재 뷰에 해당하는 필드 (포커스 비교용)
    let currentField: T
    
    /// 텍스트 입력 바인딩
    @Binding var text: String
    
    /*
    /// 유효성 검사
    let isValid: Bool?
    */
    
    // MARK: - Init
    
    /// 초기화 함수 (Binding 타입을 @Binding 변수로 연결)
    init(
        fieldType: T,
        focusedField: FocusState<T?>.Binding,
        currentField: T,
        text: Binding<String>
    ) {
        self.fieldType = fieldType
        self.focusedField = focusedField
        self.currentField = currentField
        self._text = text
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: FormTextFieldConstants.stackSpacing) {
            /// 텍스트 필드 상단 타이틀
            Text(fieldType.title)
                .font(.koRegular(size: 17))
                .foregroundStyle(Color.gray060)
            
            /// 텍스트 필드 속성 지정
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(fieldType.placeholder)
                        .foregroundStyle(Color.gray050)
                        .padding(.horizontal, 16)
                }
                
                Group {
                    if fieldType.isSecure {
                        SecureField("", text: $text)
                            .focused(focusedField, equals: currentField)
                            .submitLabel(fieldType.submitLabel)
                    } else {
                        TextField("", text: $text)
                            .focused(focusedField, equals: currentField)
                            .keyboardType(fieldType.keyboardType)
                            .submitLabel(fieldType.submitLabel)
                    }
                }
                
            } //: ZStack
            .background(
                RoundedRectangle(
                    cornerRadius: FormTextFieldConstants.cornerRadiusDegree)
                .stroke(borderColor,
                        lineWidth: FormTextFieldConstants.rectangleLinewidth)
            )
            
            /*
            /// 유효성 통과 시 체크 아이콘 , 추후 유효성 검사 로직 분리 할 예정입니다.
                if isValid == true {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green060)
                        .padding(.all, 15)
                }*/
        }
    }
    
    /// 포커스된 필드에 따른 박스 테두리 배경색 설정
    private var borderColor: Color {
            return focusedField.wrappedValue == currentField ? Color.green060 : Color.gray040
    }
}

/// FormTextField 내부에서 사용하는 상수 정의용 enum
private enum FormTextFieldConstants {
    // VStack 간격
    static let stackSpacing: CGFloat = 4
    // RoudedRectangle 테두리 둥근 정도
    static let cornerRadiusDegree: CGFloat  = 10
    // // RoudedRectangle 테두리 두께
    static let rectangleLinewidth: CGFloat = 1
}
