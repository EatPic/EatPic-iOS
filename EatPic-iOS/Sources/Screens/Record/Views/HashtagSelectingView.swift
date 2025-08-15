//
//  HashtagSelectingView.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/14/25.
//

import SwiftUI

typealias HashtagRecordVMFactory = @MainActor (_ date: Date) -> HashtagRecordViewModel

private struct AlertPayload: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct HashtagSelectingView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var recordFlowVM: RecordFlowViewModel
    
    @State private var hashtagRecordVM: HashtagRecordViewModel
    
    @State private var alert: AlertPayload?
    @State private var addHashtagSheet: Bool = false
    @State private var addHashtagText: String = ""
    
    private let columns = [
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50))
    ]
    
    init(
        date: Date = .now,
        factory: @escaping HashtagRecordVMFactory = { date in
            HashtagRecordViewModel(date: date)
        }
    ) {
        self._hashtagRecordVM = State(wrappedValue: factory(date))
    }

    var body: some View {
        ZStack {
            HastagSelectingContentView(
                hashtagRecordVM: hashtagRecordVM,
                alert: $alert,
                addHashtagSheet: $addHashtagSheet,
                addHashtagText: $addHashtagText
            )
            
            if let alert {
                AlertModalView(
                    messageTitle: alert.title,
                    messageDescription: alert.message,
                    messageColor: .black,
                    btnText: "확인",
                    btnAction: {
                        self.alert = nil
                    }
                )
            }
        }
    }
}

private struct HastagSelectingContentView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var recordFlowVM: RecordFlowViewModel
    @Bindable private var hashtagRecordVM: HashtagRecordViewModel
    
    @Binding private var alert: AlertPayload?
    @Binding private var addHashtagSheet: Bool
    @Binding private var addHashtagText: String
    
    init(
        hashtagRecordVM: HashtagRecordViewModel,
        alert: Binding<AlertPayload?>,
        addHashtagSheet: Binding<Bool>,
        addHashtagText: Binding<String>
    ) {
        self.hashtagRecordVM = hashtagRecordVM
        self._alert = alert
        self._addHashtagSheet = addHashtagSheet
        self._addHashtagText = addHashtagText
    }
    
    var body: some View {
        VStack {
            // 상단 이미지
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)

            Spacer().frame(height: 36)

            // 안내 텍스트
            Text("식사와 연관된\n해시태그를 선택해주세요")
                .font(.dsTitle2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer().frame(height: 8)

            Text("최대 3개를 선택할 수 있어요")
                .font(.dsFootnote)
                .foregroundStyle(Color.gray060)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer().frame(height: 32)

            // 해시태그 버튼 영역
            hastagBtnList()
            
            Spacer().frame(height: 80)

            addHashTagBtn

            Spacer().frame(height: 51)

            // 하단 확인 버튼
            PrimaryButton(
                color: .green060,
                text: "확인",
                font: .dsTitle3,
                textColor: .white,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                guard let selectedHashtags = hashtagRecordVM.selectedHashtags else {
                    withAnimation {
                        alert = .init(title: "안내", message: "하나 이상의 해시태그를 선택해 주세요.")
                    }
                    return
                }
                recordFlowVM.setTags(selectedHashtags)
                if recordFlowVM.canProceedToRecord {
                    container.router.push(.picCardRecord)
                }
            }
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $addHashtagSheet) {
            BottomSheetView(title: "해시태그 추가") {
                HashtagAddView(
                    hashtagInput: $addHashtagText,
                    isEnabled: .constant(hashtagRecordVM.canAdd(addHashtagText))
                ) {
                    let result = hashtagRecordVM.addCustomCategory(title: addHashtagText)
                    switch result {
                    case .success:
                        break
                    case .failure(let err):
                        withAnimation {
                            alert = .init(title: "안내", message: err.localizedDescription)
                        }
                    }
                    addHashtagSheet = false
                    addHashtagText = ""
                }
            }
            .presentationDetents([.height(200)])
        }
        .customNavigationBar {
            Text("Pic 카드 기록")
                .font(.dsTitle2)
                .foregroundStyle(Color.gray080)
        } right: {
            Button(action: {
                container.router.popToRoot()
            }, label: {
                Image("Record/btn_home_close")
            })
        }
    }
    
    private func hastagBtnList(chunkSize: Int = 4) -> some View {
        let rows = hashtagRecordVM.checks.map(\.hashtag).chunked(into: chunkSize)
        
        return LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(alignment: .top, spacing: 8) {
                    ForEach(row, id: \.self) { hashtag in
                        hashtagBtn(hashtag: hashtag)
                    }
                    
                    Spacer() // 남는 공간은 우측으로 밀어 좌측정렬 유지
                }
            }
        }
    }
    
    private func hashtagBtn(hashtag: HashtagCategory) -> some View {
        let selected = hashtagRecordVM.isSelected(hashtag.id)
        
        return Button {
            hashtagRecordVM.hashtagToggle(hashtag.id)
        } label: {
            Text("#\(hashtag.title)")
                .font(.dsCallout)
                .foregroundStyle(
                    selected ? Color.green060: .gray050)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    selected ? Color.green010: Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(
                            selected ? Color.green060: Color.gray050,
                            lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(!selected && !hashtagRecordVM.canSelectMore) // 3개 이상 선택시 나머지 비활성화
    }
    
    private var addHashTagBtn: some View {
        HStack {
            Spacer()
            
            Button {
                addHashtagSheet.toggle()
            } label: {
                HStack {
                    Text("직접 추가하기")
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray060)
                    Spacer()
                    Image("Record/btn_record_add")
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(width: 135, height: 38)
                .background(Color.gray020)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)

            Spacer()
        }
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [self] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    HashtagSelectingView()
        .environmentObject(RecordFlowViewModel())
        .environmentObject(DIContainer())
}
