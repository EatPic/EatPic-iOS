//
//  PicCardRecordView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/10/25.
//

import SwiftUI

struct PicCardRecordView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var recordFlowVM: RecordFlowViewModel
    
    @State private var picCardRecordVM: PicCardRecordViewModel
    
    @State private var memo: String = ""
    @State private var recipeContent: String = ""
    @State private var recipeLink: String = ""
    @State private var storeLocation: PicCardStoreLocation = .init(name: "")
    @State private var sharedFeed: Bool = false
    
    @State private var showAddRecipeSheet: Bool = false
    @State private var showAddStoreLocationSheet: Bool = false
    
    init(container: DIContainer, recordFlowVM: RecordFlowViewModel) {
        self._picCardRecordVM = .init(
            wrappedValue: .init(container: container, recordFlowVM: recordFlowVM))
    }

    var body: some View {
        VStack {
            PicCardWriteView(
                primaryButtonText: "기록하기",
                onPrimaryButtonTap: {
                    recordFlowVM.setMemo(memo)
                    recordFlowVM.setRecipeText(recipeContent)
                    recordFlowVM.setRecipeLink(recipeLink)
                    recordFlowVM.setStoreLocation(storeLocation)
                    
                    container.router.popToRoot()
                },
                onAddReceiptTap: {
                    showAddRecipeSheet = true
                },
                onAddStoreLocationTap: {
                    showAddStoreLocationSheet = true
                },
                myMemo: $memo,
                receiptDetail: $recipeContent,
                isSharedToFeed: $sharedFeed
            )
        }
        .sheet(isPresented: $showAddRecipeSheet) {
            BottomSheetView(title: "레시피 링크 추가") {
                BottomSheetTextFieldView(
                    input: $recipeLink,
                    isEnabled: .constant(true) // 추후 리팩토링
                ) {
                    recordFlowVM.setRecipeLink(recipeLink)
                    showAddRecipeSheet = false
                }
            }
            .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $showAddStoreLocationSheet) {
            BottomSheetView(title: "식당 위치 추가") {
                // 식당 검색
            }
            .presentationDetents([.height(200)])
        }
        .customNavigationBar { Text("Pic 카드 기록") } right: {
            Button { container.router.popToRoot() } label: {
                Image("Record/btn_home_close")
            }
        }
    }
}

private struct BottomSheetTextFieldView: View {
    @Binding private var input: String
    @Binding private var isEnabled: Bool
    private let onAddHashtag: () -> Void
    private let placeholder: String
    
    init(
        input: Binding<String>,
        isEnabled: Binding<Bool>,
        onAddHashtag: @escaping () -> Void,
        placeholder: String = ""
    ) {
        self._input = input
        self._isEnabled = isEnabled
        self.onAddHashtag = onAddHashtag
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 9) {
                TextField(placeholder, text: $input)
                    .font(.dsBody)
                    .foregroundStyle(Color.gray080)
                    .padding(9.5)
                    .background(Color.white000)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .lineLimit(1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isEnabled ? Color.green060 : Color.red050,
                                lineWidth: 1
                            )
                    )
                
                PrimaryButton(
                    color: isEnabled ? .green060 : .gray040,
                    text: "추가",
                    font: .dsHeadline,
                    textColor: isEnabled ? .white : .gray060,
                    width: 64,
                    height: 40,
                    cornerRadius: 10
                ) {
                    onAddHashtag()
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    PicCardRecordView(container: .init(), recordFlowVM: .init())
        .environmentObject(DIContainer())
        .environmentObject(RecordFlowViewModel())
}
