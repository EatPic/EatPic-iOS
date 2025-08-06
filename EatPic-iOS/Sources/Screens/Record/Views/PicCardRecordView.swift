//
//  PicCardWritingView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/30/25.
//

//
//  PicCardEditView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/28/25.
//

import SwiftUI

struct PicCardRecordView: View {
    // 바텀 시트 표시 여부
    @State private var showHashtagAddSheet = false

    @EnvironmentObject private var container: DIContainer
    
    let selectedMeal: MealType
    let selectedHashtags: [String]
    
    // MARK: - Init
    init(selectedMeal: MealType, selectedHashtags: [String]) {
        self.selectedMeal = selectedMeal
        self.selectedHashtags = selectedHashtags
    }
    
    var body: some View {
        VStack {
            PicCardWriteView(
                primaryButtonText: "저장하기",
                onSave: { myMemo, receiptDetail, isSharedToFeed in
                    savePicCard(myMemo: myMemo,
                                receiptDetail: receiptDetail,
                                isSharedToFeed: isSharedToFeed)
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
    }
    
    // MARK: - 저장 로직
    private func savePicCard(myMemo: String, receiptDetail: String, isSharedToFeed: Bool) {
        // TODO: [25.08.07] 실제 데이터 저장 로직 구현 - 비엔/이은정
        print("Pic 카드 저장:")
        print("- 선택된 식사 시간: \(selectedMeal.rawValue)")
        print("- 선택된 해시태그: \(selectedHashtags)")
        print("- 나의 메모: \(myMemo)")
        print("- 레시피 내용: \(receiptDetail)")
        print("- 피드 공유 여부: \(isSharedToFeed)")
        
        // 저장 완료 후 MainTab 화면으로 돌아가기
        container.router.popToRoot()
    }
}

//#Preview {
//    PicCardRecordView()
//}
