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
    
    @State var memo: String = ""
    @State var recipeContent: String = ""
    @State var recipeLink: String = ""
    @State var storeLocation: PicCardStoreLocation = .init(name: "")
    @State var sharedFeed: Bool = false
    
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
                    
                    Task {
                        await picCardRecordVM.createPicCard()
                    }
                },
                onAddReceiptTap: {
                    print("onAddReceiptTap")
                },
                onAddStoreLocationTap: {
                    print("onAddStoreLocationTap")
                },
                myMemo: $memo,
                receiptDetail: $recipeContent,
                isSharedToFeed: $sharedFeed
            )
        }
        .customNavigationBar { Text("Pic 카드 기록") } right: {
            Button { container.router.popToRoot() } label: {
                Image("Record/btn_home_close")
            }
        }
    }
}

#Preview {
    PicCardRecordView(container: .init(), recordFlowVM: .init())
        .environmentObject(DIContainer())
        .environmentObject(RecordFlowViewModel())
}
