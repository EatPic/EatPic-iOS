//
//  HashtagRecordModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation

enum HashtagKind: String, CaseIterable, Sendable, Equatable {
    case midnightSnack = "야식"
    case brunch = "브런치"
    case eatingAlone = "혼밥"
    case homeMeal = "집밥"
    case dietControl = "식단관리"
    case selfCooking = "자취생"
    case health = "건강"
    case gourmet = "맛집"
    case vegan = "비건"
    case korean = "한식"
    case western = "양식"
    case chinese = "중식"
    case japanese = "일식"
}

struct HashtagCheck {
    let id: HashtagKind
    var selected: Bool
    var selectedAt: Date?
    
    init(id: HashtagKind, selected: Bool = false, selectedAt: Date? = nil) {
        self.id = id
        self.selected = selected
        self.selectedAt = selectedAt
    }
}

struct HashtagRecordModel {
    private let maxSelectedCount: Int = 3
    
    var date: Date
    var checks: [HashtagCheck]
    
    init(date: Date, checks: [HashtagCheck]) {
        self.date = date
        self.checks = checks
    }
    
    var selectedHashtags: [HashtagKind] {
        checks.filter { $0.selected }.map { $0.id }
    }
    
    var selectedCount: Int { selectedHashtags.count }
    
    var canSelectMore: Bool { selectedCount < maxSelectedCount }
    
    var isFull: Bool { selectedCount == maxSelectedCount }
    
    func check(of hashtag: HashtagKind) -> HashtagCheck? {
        checks.first { $0.id == hashtag }
    }
    
    mutating func togle(_ hashtag: HashtagKind, at time: Date = .now) {
        guard let idx = checks.firstIndex(where: { $0.id == hashtag}) else { return }
        checks[idx].selected.toggle()
        checks[idx].selectedAt = checks[idx].selected ? time : nil
    }
    
    mutating func markUploaded(_ hashtag: HashtagKind, at time: Date = .now) {
        guard let idx = checks.firstIndex(where: { $0.id == hashtag }) else { return }
        
        if checks[idx].selected {
            // 이미 선택된 것은 언제든 해제 가능
            checks[idx].selected = false
            checks[idx].selectedAt = nil
        } else if canSelectMore {
            // 남은 해시태그가 있을 때만 선택
            checks[idx].selected = true
            checks[idx].selectedAt = time
        }
        // 해시태그가 가득 찼고(=canSelectMore == false) 미선택을 누르면 무시
    }
}

extension HashtagRecordModel {
    static func initial(for date: Date = .now) -> Self {
        .init(
            date: date,
            checks: HashtagKind.allCases.map { .init(id: $0, selected: false) }
        )
    }
}

@Observable
@MainActor
final class HashtagRecordViewModel {
    private(set) var model: HashtagRecordModel
    
    init(model: HashtagRecordModel = .initial()) {
        self.model = model
    }
    
    var date: Date { model.date }
    var selectedHashtags: [HashtagKind]? { model.selectedHashtags }
    var selectedCount: Int { model.selectedCount }
    var canSelectMore: Bool { model.canSelectMore }
    var isFull: Bool { model.isFull }
    
    // MARK: - 조회
    
    func isSelected(_ hashtag: HashtagKind) -> Bool {
        model.check(of: hashtag)?.selected == true
    }
    
    func selectedAt(_ hashtag: HashtagKind) -> Date? {
        model.check(of: hashtag)?.selectedAt
    }
    
    // MARK: - Domain Mutation (사이드 이팩트 free)
    
    func hashtagTogle(_ hashtag: HashtagKind, at time: Date = .now) {
        model.togle(hashtag, at: time)
    }
    
    func markUploaded(hashtag: HashtagKind, at time: Date = .now) {
        model.markUploaded(hashtag, at: time)
    }
    
    func reset(for date: Date = .now) {
        model = .initial(for: date)
    }
}

import SwiftUI

typealias HashtagRecordVMFactory = @MainActor (_ date: Date) -> HashtagRecordViewModel

struct HashtagSelectingView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var recordFlowVM: RecordFlowViewModel
    @State private var hashtagRecordVM: HashtagRecordViewModel
    @State private var showAlert: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50))
    ]
    
    init(
        date: Date = .now,
        factory: @escaping HashtagRecordVMFactory = {
            HashtagRecordViewModel(model: .initial(for: $0))
        }
    ) {
        self._hashtagRecordVM = State(wrappedValue: factory(date))
    }

    var body: some View {
        ZStack {
            HastagSelectingContentView(
                hashtagRecordVM: hashtagRecordVM,
                showAlert: $showAlert
            )
            
            if showAlert {
                AlertModalView(
                    messageTitle: "안내",
                    messageDescription: "하나 이상의 해시태그를 선택해 주세요.",
                    messageColor: .black,
                    btnText: "확인",
                    btnAction: {
                        showAlert = false
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
    
    @Binding private var showAlert: Bool
    
    init(
        hashtagRecordVM: HashtagRecordViewModel,
        showAlert: Binding<Bool>
    ) {
        self.hashtagRecordVM = hashtagRecordVM
        self._showAlert = showAlert
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
                    print("선택된 해시태그가 없음")
                    return
                }
                recordFlowVM.setTags(selectedHashtags)
                if recordFlowVM.canProceedToRecord {
                    container.router.push(.picCardRecord)
                } else {
                    withAnimation {
                        showAlert = true
                    }
                }
            }
        }
        .padding(.horizontal, 16)
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
    
    private func hastagBtnList(chunkSize: Int = 4) -> some View {
        let rows = HashtagKind.allCases.chunked(into: chunkSize)
        
        return LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(alignment: .top, spacing: 8) {
                    ForEach(row, id: \.self) { kind in
                        hashtagBtn(hastagKind: kind)
                    }
                    
                    Spacer() // 남는 공간은 우측으로 밀어 좌측정렬 유지
                }
            }
        }
    }
    
    private func hashtagBtn(hastagKind: HashtagKind) -> some View {
        let selected = hashtagRecordVM.isSelected(hastagKind)
        
        return Button {
            hashtagRecordVM.hashtagTogle(hastagKind)
        } label: {
            Text("#\(hastagKind.rawValue)")
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
                // 해시태그 추가 액션 작성
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
}
