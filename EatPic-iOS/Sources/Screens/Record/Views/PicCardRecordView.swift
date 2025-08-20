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
    @State private var recipeLinkURL: String = ""
    @State private var storeLocation: PicCardStoreLocation = .init(name: "")
    @State private var storeLocationTitle: String = ""
    @State private var sharedFeed: Bool = false
    
    @State private var showAddRecipeSheet: Bool = false
    @State private var showAddStoreLocationSheet: Bool = false
    
    @State private var showDuplicateAlert = false
    
    private let storeLocationSheetHeight: CGFloat = 400
    
    init(container: DIContainer, recordFlowVM: RecordFlowViewModel) {
        self._picCardRecordVM = .init(
            wrappedValue: .init(container: container, recordFlowVM: recordFlowVM))
    }

    var body: some View {
        VStack {
            PicCardWriteView(
                primaryButtonText: "기록하기",
                recipeLinkTitle: recipeLinkURL.isEmpty ? "레시피 링크 추가" : recipeLinkURL,
                storeLocationTitle:
                    storeLocationTitle.isEmpty ? "식당 위치 추가" : storeLocationTitle,
                recipeLinkTitleColor:
                    recipeLinkURL.isEmpty ? Color.gray080 : .green060,
                storeLocationTitleColor:
                    storeLocationTitle.isEmpty ? Color.gray080 : .green060,
                onPrimaryButtonTap: {
                    recordFlowVM.setMemo(memo)
                    recordFlowVM.setRecipeText(recipeContent)
                    recordFlowVM.setRecipeLink(recipeLink)
                    recordFlowVM.setStoreLocation(storeLocation)
                    recordFlowVM.setSharedFeed(sharedFeed)
                    recordFlowVM.setStoreLocation(storeLocation)
                    
                    Task {
                        await picCardRecordVM.createPicCard()
                        if picCardRecordVM.isDuplicateMealConflict {
                            showDuplicateAlert = true
                        } else {
                            container.router.popToRoot()
                        }
                    }
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
                    recipeLinkURL = recipeLink
                    recordFlowVM.setRecipeLink(recipeLinkURL)
                    showAddRecipeSheet = false
                }
            }
            .presentationDetents([.height(150)])
        }
        .sheet(isPresented: $showAddStoreLocationSheet) {
            BottomSheetView(title: "식당 위치 추가") {
                searchStoreLocationView
            }
            .presentationDetents([.height(storeLocationSheetHeight)])
        }
        .customNavigationBar { Text("Pic 카드 기록") } right: {
            Button { container.router.popToRoot() } label: {
                Image("Record/btn_home_close")
            }
        }
        .alert(
            "업로드 불가",
            isPresented: $showDuplicateAlert,
            actions: {
                Button("확인", role: .cancel) { }
            },
            message: {
                Text(picCardRecordVM.errorMessage ?? "이미 같은 날짜와 같은 식사 유형의 카드가 존재합니다.")
            }
        )
    }
    
    private var searchStoreLocationView: some View {
        VStack {
            SearchBarView(
                text: $storeLocationTitle,
                placeholder: "장소를 검색하세요",
                showsDeleteButton: false,
                backgroundColor: .gray020,
                strokeColor: nil,
                onSubmit: {
                    //
                },
                onChange: { _ in
                    picCardRecordVM.search(query: storeLocationTitle)
                }
            )
            
            Spacer().frame(height: 20)

            List(picCardRecordVM.searchResults) { place in
                VStack(alignment: .leading) {
                    Text(place.mapItem.name ?? "이름 없음")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray080)
                    Text(place.mapItem.placemark.title ?? "")
                        .font(.dsFootnote)
                        .foregroundStyle(Color.gray060)
                }
                .onTapGesture {
                    storeLocationTitle = place.mapItem.name ?? "이름 없음"
                    storeLocation.latitude = place.mapItem.placemark.coordinate.latitude
                    storeLocation.longitude = place.mapItem.placemark.coordinate.longitude
                    storeLocation.name = storeLocationTitle
                    showAddStoreLocationSheet = false
                }
            }
            .listStyle(.plain)
            .listRowSpacing(10)
        }
        .padding(.horizontal, 16)
        .frame(height: storeLocationSheetHeight - 100)
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
