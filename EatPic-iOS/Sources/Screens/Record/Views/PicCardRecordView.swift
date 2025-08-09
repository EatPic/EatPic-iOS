//
//  PicCardRecordView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

import SwiftUI

struct PicCardRecordView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel: PicCardRecordViewModel
    
    // MARK: - Init
    init(selectedMeal: MealType, selectedHashtags: [String]) {
        self._viewModel = StateObject(wrappedValue: PicCardRecordViewModel(
            selectedMeal: selectedMeal, 
            selectedHashtags: selectedHashtags
        ))
    }
    
    var body: some View {
        VStack {
            PicCardWriteView(
                primaryButtonText: viewModel.isSaving ? "저장 중..." : "저장하기",
                onSave: { myMemo, receiptDetail, isSharedToFeed in
                    viewModel.savePicCard(
                        myMemo: myMemo,
                        receiptDetail: receiptDetail,
                        isSharedToFeed: isSharedToFeed
                    )
                }
            )
        }
        .customNavigationBar {
            Text("Pic 카드 기록")
        } right: {
            Button(action: {
                container.router.popToRoot()
            }, label: {
                Image("Record/btn_home_close")
            })
        }
        .onChange(of: viewModel.state) { _, newState in
            if case .saved = newState {
                // 저장 완료 후 MainTab 화면으로 돌아가기
                print("저장 완료! 홈으로 이동합니다.")
                container.router.popToRoot()
            }
        }
        .alert("저장 실패", isPresented: .constant(viewModel.hasError)) {
            Button("확인") {
                viewModel.resetState()
            }
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.")
        }
    }
}
