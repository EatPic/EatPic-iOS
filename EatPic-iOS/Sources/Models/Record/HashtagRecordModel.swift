//
//  HashtagRecordModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation

// MARK: - Catalog (Data-driven)

/// 해시태그의 데이터 모델
///
/// - Note: `id`는 서버 코드나 영속 키 사용(서비스에 의해 제공되는 고정 문자열).
/// 런타임에 사용자 정의 태그를 추가해도 충돌 없이 동작합니다.
struct HashtagCategory: Identifiable, Hashable, Sendable {
    let id: String
    var title: String
    
    init(id: String, title: String) {
        self.id = id        // e.g. "midnightSnack"
        self.title = title  // e.g. "야식"
    }
}

/// 해시태그 목록 소스(내장/원격/로컬 합성 가능)
protocol HashtagCatalogProviding: Sendable {
    var all: [HashtagCategory] { get }
}

struct DefaultHashtagCatalog: HashtagCatalogProviding {
    var all: [HashtagCategory] {
        [
            .init(id: "midnightSnack", title: "야식"),
            .init(id: "brunch", title: "브런치"),
            .init(id: "eatingAlone", title: "혼밥"),
            .init(id: "homeMeal", title: "집밥"),
            .init(id: "dietControl", title: "식단관리"),
            .init(id: "selfCooking", title: "자취생"),
            .init(id: "health", title: "건강"),
            .init(id: "gourmet", title: "맛집"),
            .init(id: "vegan", title: "비건"),
            .init(id: "korean", title: "한식"),
            .init(id: "western", title: "양식"),
            .init(id: "chinese", title: "중식"),
            .init(id: "japanese", title: "일식"),
        ]
    }
}

/// 해시태그 선택 상태를 나타내는 개별 단위 모델.
///
/// - Parameters:
///   - id: 해시태그 종류(`HashtagKind`)
///   - selected: 현재 선택 여부
///   - selectedAt: 선택 시각 (선택 해제 시 `nil`)
struct HashtagCheck: Sendable {
    let hashtag: HashtagCategory
    var selected: Bool
    var selectedAt: Date?
    
    init(hashtag: HashtagCategory, selected: Bool = false, selectedAt: Date? = nil) {
        self.hashtag = hashtag
        self.selected = selected
        self.selectedAt = selectedAt
    }
}

// MARK: - Domain aggregate

/// 해시태그 선택 관련 도메인 모델.
///
/// 이 모델은 하나의 기록 날짜(`date`)에 대해 선택 가능한 모든 해시태그의 상태를 관리합니다.
///
/// **도메인 규칙**
/// - 최대 3개의 해시태그만 선택할 수 있습니다.
/// - 이미 선택된 해시태그는 언제든 해제할 수 있습니다.
/// - 최대 개수에 도달한 상태에서 미선택 해시태그를 선택하려고 하면 무시됩니다.
struct HashtagRecordModel {
    // MARK: - Domain Constants
        
    /// 선택 가능한 최대 해시태그 수
    private let maxSelectedCount: Int = 3
    
    // MARK: - Domain State
    
    var date: Date
    var checks: [HashtagCheck]
    
    // MARK: - init
    
    init(date: Date, checks: [HashtagCheck]) {
        self.date = date
        self.checks = checks
    }
    
    // MARK: - Domain Derived Properties
    
    var selectedHashtags: [HashtagCategory] {
        checks.filter { $0.selected }.map { $0.hashtag }
    }
    
    var selectedCount: Int { selectedHashtags.count }
    
    var canSelectMore: Bool { selectedCount < maxSelectedCount }
    
    var isFull: Bool { selectedCount == maxSelectedCount }
    
    func check(of hashtagId: HashtagCategory.ID) -> HashtagCheck? {
        checks.first { $0.hashtag.id == hashtagId }
    }
    
    // MARK: - Side Effects (State Mutations)
    
    mutating func toggle(_ hashtagId: HashtagCategory.ID, at time: Date = .now) {
        guard let idx = checks.firstIndex(where: { $0.hashtag.id == hashtagId }) else { return }
        checks[idx].selected.toggle()
        checks[idx].selectedAt = checks[idx].selected ? time : nil
    }
    
    // 업로드 후의 선택 규칙
    mutating func markUploaded(_ hashtagId: HashtagCategory.ID, at time: Date = .now) {
        guard let idx = checks.firstIndex(where: { $0.hashtag.id == hashtagId }) else { return }
        
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
    
    /// 런타임에 카테고리를 추가(뷰에서 신규 해시태그 생성 시)
    mutating func appendCategoryIfNeeded(_ newHashtag: HashtagCategory) {
        guard checks.contains(where: {
            $0.hashtag.id == newHashtag.id }) == false else { return }
        checks.append(.init(hashtag: newHashtag))
    }
}

extension HashtagRecordModel {
    static func initial(
        for date: Date = .now,
        catalog: HashtagCatalogProviding = DefaultHashtagCatalog()
    ) -> Self {
        .init(
            date: date,
            checks: catalog.all.map { .init(hashtag: $0, selected: false) }
        )
    }
}

@Observable
@MainActor
final class HashtagRecordViewModel {
    private(set) var model: HashtagRecordModel
    private(set) var catalog: HashtagCatalogProviding
    
    init(
        date: Date = .now,
        catalog: HashtagCatalogProviding = DefaultHashtagCatalog()
    ) {
        self.catalog = catalog
        self.model = .initial(for: date, catalog: catalog)
    }
    
    var date: Date { model.date }
    var selectedHashtags: [HashtagCategory]? { model.selectedHashtags }
    var selectedCount: Int { model.selectedCount }
    var canSelectMore: Bool { model.canSelectMore }
    var isFull: Bool { model.isFull }
    
    // MARK: - 조회
    
    func isSelected(_ id: HashtagCategory.ID) -> Bool {
        model.check(of: id)?.selected == true
    }
    
    func selectedAt(_ id: HashtagCategory.ID) -> Date? {
        model.check(of: id)?.selectedAt
    }
    
    // MARK: - Domain Mutation (사이드 이팩트 free)
    
    func hashtagToggle(_ id: HashtagCategory.ID, at time: Date = .now) {
        model.toggle(id, at: time)
    }
    
    func markUploaded(_ id: HashtagCategory.ID, at time: Date = .now) {
        model.markUploaded(id, at: time)
    }
    
    func reset(for date: Date = .now) {
        model = .initial(for: date, catalog: catalog)
    }
    
    // MARK: Runtime extension (사용자에 의한 태그 추가)
    
    /**
     뷰에서 사용자 정의 해시태그를 추가할 때 사용.
     
     - Parameters:
     - id: 영속/서버 키(중복 방지용). 비워두면 `title` 기반으로 생성합니다.
     - title: 표시용 텍스트
     - selectImmediately: 추가 직후 선택할지 여부(기본 `false`)
     */
    func addCustomCategory(
        id: String? = nil,
        title: String,
        selectImmediately: Bool = false
    ) {
        let key = id ?? title.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "_")
        
        let category = HashtagCategory(id: key, title: title)
        model.appendCategoryIfNeeded(category)
        
        if selectImmediately {
            model.toggle(key)
        }
    }
}

import SwiftUI

typealias HashtagRecordVMFactory = @MainActor (_ date: Date) -> HashtagRecordViewModel

struct HashtagSelectingView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var recordFlowVM: RecordFlowViewModel
    
    @State private var hashtagRecordVM: HashtagRecordViewModel
    
    @State private var showAlert: Bool = false
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
                showAlert: $showAlert,
                addHashtagSheet: $addHashtagSheet,
                addHashtagText: $addHashtagText
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
    @Binding private var addHashtagSheet: Bool
    @Binding private var addHashtagText: String
    
    init(
        hashtagRecordVM: HashtagRecordViewModel,
        showAlert: Binding<Bool>,
        addHashtagSheet: Binding<Bool>,
        addHashtagText: Binding<String>
    ) {
        self.hashtagRecordVM = hashtagRecordVM
        self._showAlert = showAlert
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
        .sheet(isPresented: $addHashtagSheet) {
            BottomSheetView(title: "해시태그 추가") {
                HashtagAddView(
                    hashtagInput: $addHashtagText,
                    isEnabled: true
                ) {
                    hashtagRecordVM.addCustomCategory(title: addHashtagText)
                    addHashtagSheet = false
                }
            }
            .presentationDetents([.height(200)])
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
    
    private func hastagBtnList(chunkSize: Int = 4) -> some View {
        let rows = hashtagRecordVM.catalog.all.chunked(into: chunkSize)
        
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

