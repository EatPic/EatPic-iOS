//
//  PicCardWritView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/10/25.
//

import SwiftUI

struct PicCardRecorView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewmodel: PicCardRecorViewModel

    var body: some View {
        VStack {
            PicCardWriteView(
                primaryButtonText: "저장하기",
                // recordModel의 각 필드에 수동 바인딩을 만들어서 연결
                // TODO: [25.08.10] 수동바인딩? -> Observable쓰면 자동 바인딩 아닌가
                myMemo: Binding(
                    get: { viewmodel.recordModel.memo },
                    set: { viewmodel.recordModel.memo = $0 }
                ),
                receiptDetail: Binding(
                    get: { viewmodel.recordModel.recipe },
                    set: { viewmodel.recordModel.recipe = $0 }
                ),
                isSharedToFeed: Binding(
                    get: { viewmodel.recordModel.isShared },
                    set: { viewmodel.recordModel.isShared = $0 }
                )
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
    PicCardRecorView()
        .environmentObject(PicCardRecorViewModel())
}
