//
//  PicCardWritView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/10/25.
//

import SwiftUI

struct PicCardRecordView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var recordFlowVM: RecordFlowViewModel
    @State private var picCardRecordVM: PicCardRecordViewModel
    
    init(container: DIContainer, recordFlowVM: RecordFlowViewModel) {
        self._picCardRecordVM = .init(
            wrappedValue: .init(container: container, recordFlowVM: recordFlowVM))
    }

    var body: some View {
        VStack {
//            PicCardWriteView(
//                primaryButtonText: "기록하기",
//                // recordModel의 각 필드에 수동 바인딩을 만들어서 연결
//                myMemo: Binding(
//                    get: { viewmodel.recordModel.memo },
//                    set: { viewmodel.recordModel.memo = $0 }
//                ),
//                receiptDetail: Binding(
//                    get: { viewmodel.recordModel.recipe },
//                    set: { viewmodel.recordModel.recipe = $0 }
//                ),
//                isSharedToFeed: Binding(
//                    get: { viewmodel.recordModel.isShared },
//                    set: { viewmodel.recordModel.isShared = $0 }
//                )
//            )
            Button {
                Task {
                    await picCardRecordVM.createPicCard()
                }
                print("Button Click")
            } label: {
                Text("Button")
            }
        }
        .customNavigationBar { Text("Pic 카드 기록") } right: {
            Button { container.router.popToRoot() } label: {
                Image("Record/btn_home_close")
            }
        }
    }
}

//#Preview {
//    PicCardRecordView(container: <#DIContainer#>, recordFlowVM: <#RecordFlowViewModel#>)
//        .environmentObject(DIContainer())
//        .environmentObject(RecordFlowViewModel())
//}
