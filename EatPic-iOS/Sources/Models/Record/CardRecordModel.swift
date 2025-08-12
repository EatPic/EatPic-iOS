//
//  CardRecordModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/12/25.
//

import Foundation

public enum MealSlot: String, CaseIterable, Sendable, Equatable {
    case breakfast, lunch, dinner, snack
}

/// 개별 끼니의 상태
/// - uploaded: 업로드 완료(체크 고정, 선택 불가)
/// - selected: 업로드 전 사용자가 현재 선택한 끼니(단일 선택)
struct MealCheck {
    let id: MealSlot
    var uploaded: Bool
    var uploadedAt: Date?
    var selected: Bool
    var selectedAt: Date?
    
    init(
        id: MealSlot,
        uploaded: Bool = false,
        uploadedAt: Date? = nil,
        selected: Bool = false,
        selectedAt: Date? = nil
    ) {
        self.id = id
        self.uploaded = uploaded
        self.uploadedAt = uploadedAt
        self.selected = selected
        self.selectedAt = selectedAt
    }
}

struct MealRecordModel {
    var date: Date
    var checks: [MealCheck]   // 항상 4개(아/점/저/간)

    init(date: Date, checks: [MealCheck]) {
        self.date = date
        self.checks = checks
        enforceSelectionInvariant()
    }

    // 업로드 완료된 끼니 수(체크 수 고정)
    var uploadedCount: Int { checks.filter { $0.uploaded }.count }
    
    /// 아직 업로드 안 된(선택 가능) 끼니들
    var selectableSlots: [MealSlot] {
        checks.filter { !$0.uploaded }.map(\.id)
    }
    
    /// 현재 선택된 끼니(업로드 전 단일 선택)
    var selectedSlot: MealSlot? { checks.first(where: { $0.selected })?.id }
    
    // 업로드 안 된 끼니가 존재하는가
    var hasSelectable: Bool { checks.contains { !$0.uploaded }}
    
    // MARK: - 조회

    func check(of slot: MealSlot) -> MealCheck? {
        checks.first { $0.id == slot }
    }
    
    // MARK: - 도메인 규칙
    // 단일 선택 + 업로드 잠금 불변식 유지
    
    /// 사용자가 끼니를 선택.
    /// - 업로드된 끼니는 선택 불가(무시)
    /// - 업로드 전 끼니는 **해당 끼니만 선택**되도록 나머지 선택 해제
    mutating func select(_ slot: MealSlot, at time: Date = .now) {
        guard let mealCheckIdx = checks.firstIndex(where: { $0.id == slot }) else { return }
        guard checks[mealCheckIdx].uploaded == false else { return } // 잠금 중이면 무시
        
        for checkIdx in checks.indices {
            if checkIdx == mealCheckIdx {
                checks[checkIdx].selected = true
                checks[checkIdx].selectedAt = time
            } else if checks[checkIdx].uploaded == false {
                checks[checkIdx].selected = false
                checks[checkIdx].selectedAt = nil
            }
        }
    }

    /// 업로드 성공 처리.
    /// - 선택 여부와 관계없이 해당 슬랏을 업로드 완료로 잠그고, 선택 해제
    /// - 남은 미업로드 끼니 중 **정확히 하나**가 선택되도록 보정
    mutating func markUploaded(_ slot: MealSlot, at time: Date = .now) {
        guard let idx = checks.firstIndex(
            where: { $0.id == slot }) else { return }
        
        checks[idx].uploaded = true
        checks[idx].uploadedAt = time
        checks[idx].selected = false
        checks[idx].selectedAt = nil
        
         enforceSelectionInvariant()
    }
    
    /// 업로드 삭제(사용자 의도적 취소).
    /// - 해당 끼니를 미업로드 상태로 되돌리고, 단일 선택 불변식을 재적용
    mutating func deleteUploaded(_ slot: MealSlot, at time: Date = .now) {
        guard let idx = checks.firstIndex(
            where: { $0.id == slot }) else { return }
        checks[idx].uploaded = false
        checks[idx].uploadedAt = nil
        
        // 일단 기존 선택 유지, 선택이 없는 경우 해당 슬롯을 선택
        if selectedSlot == nil {
            checks[idx].selected = true
            checks[idx].selectedAt = time
        }
    }
    
    /// 불변식: **정확히 하나만 선택**되어야 함.
    /// 가장 최근 선택(at) 1개만 남기고 나머지 해제
    private mutating func enforceSelectionInvariant() {
        let selectableIdxs = checks.indices.filter {
            checks[$0].uploaded == false
        }
        // 선택 가능 항목이 없으면 전체 선택 해제
        guard selectableIdxs.isEmpty == false else {
            for idx in checks.indices {
                checks[idx].selected = false
                checks[idx].selectedAt = nil
            }
            return
        }
        
        let selectedIdxs = selectableIdxs.filter { checks[$0].selected }
        // 최근 선택 1개만 유지
        let sorted = selectedIdxs.sorted {
            let selected1 = checks[$0].selectedAt ?? .distantFuture
            let selected2 = checks[$1].selectedAt ?? .distantPast
            
            return selected1 > selected2
        }
        
        guard let keeper = sorted.first else { return }
        for idx in sorted.dropFirst() {
            checks[idx].selected = false
            checks[idx].selectedAt = nil
        }
        checks[keeper].selected = true
    }
}

extension MealRecordModel {
    static func initial(for date: Date = .now) -> Self {
        .init(
            date: date,
            checks: MealSlot.allCases.map { MealCheck(id: $0) }
        )
    }
}

/// 끼니 기록 카드의 상태를 관리하는 ViewModel.
/// - 책임: 도메인 모델(`MealRecordModel`)의 읽기/갱신과 파생 상태 계산.
/// - 비고: 권한/촬영/업로드 등 부작용은 UseCase에서 처리한 뒤,
///         최종적으로 `markRecorded(slot:at:)`을 호출하여 상태만 갱신합니다.
@MainActor
final class MealRecordViewModel: ObservableObject {

    /// 현재 화면에 표시할 도메인 모델
    @Published private(set) var model: MealRecordModel

    // MARK: - Init
    init(model: MealRecordModel = .initial()) {
        self.model = model
    }

    // MARK: - Driven States
    var date: Date { model.date }
    var uploadedCount: Int { model.uploadedCount }
    var hasSelectable: Bool { model.hasSelectable }
    var selectedSlot: MealSlot? { model.selectedSlot }
    
    // MARK: - 조회
    
    func isUploaded(_ slot: MealSlot) -> Bool {
        model.check(of: slot)?.uploaded == true
    }
    func isSelected(_ slot: MealSlot) -> Bool {
        model.check(of: slot)?.selected == true
    }
    func uploadedAt(_ slot: MealSlot) -> Date? {
        model.check(of: slot)?.uploadedAt
    }
    func selectedAt(_ slot: MealSlot) -> Date? {
        model.check(of: slot)?.selectedAt
    }

    // MARK: - Domain Mutations (Side-effect free)
    
    func select(_ slot: MealSlot) {
        model.select(slot, at: .now)
    }

    /// 도메인 모델에 위임하여 슬롯을 기록 상태로 전환합니다.
    /// - Parameters:
    ///   - slot: 기록할 끼니 슬롯
    ///   - time: 기록 시각(일반적으로 `.now`)
    func markUploaded(slot: MealSlot, at time: Date = .now) {
        model.markUploaded(slot, at: time)
    }
    
    func deleteUploaded(_ slot: MealSlot) {
        model.deleteUploaded(slot, at: .now)
    }

    /// 오늘 날짜로 초기화
    func reset(for date: Date = .now) {
        model = .initial(for: date)
    }
}

/// 기록하기 플로우의 단계
public enum RecordStep: Equatable {
    case mealTime        // 끼니 선택/업로드 잠금 화면 (MealRecordView)
    case tagSelect       // 태그 선택 (미구현: 후속 단계에서 연결)
    case note            // 노트 입력 (미구현)
    case uploading       // 업로드 진행 (미구현)
    case done            // 완료
}

typealias MealRecordVMFactory = (_ date: Date) -> MealRecordViewModel

@MainActor
final class RecordFlowRootViewModel: ObservableObject {
    private let mealRecordVMFactory: MealRecordVMFactory = { date in
        MealRecordViewModel(model: .initial(for: date))
    }
    
    @Published private(set) var step: RecordStep = .mealTime
    @Published private(set) var mealRecordVM: MealRecordViewModel?
    
    /// 루트 플로우 시작
    /// - Parameter date: 오늘 날짜(또는 특정 날짜) 기준으로 시작
    public func start(date: Date = .now) {
        self.mealRecordVM = mealRecordVMFactory(date)
        self.step = .mealTime
    }
    
    // MARK: Flow transitions
    
    /// 끼니 선택/업로드 화면에서 "다음"으로 진행할 때 호출
    /// - 정책: 지금은 태그 선택 단계로 이동시키되, 후에 조건/가드 추가 가능
    public func proceedFromMealSelection() {
        self.step = .tagSelect
    }
    
    /// 뒤로 가기
    public func back() {
        switch step {
        case .mealTime:
            // 플로우 시작 이전으로 나가거나, 외부 라우팅에 위임
            break
        case .tagSelect:
            self.step = .mealTime
        case .note:
            self.step = .tagSelect
        case .uploading:
            self.step = .note
        case .done:
            // 완료에서 뒤로 가면 홈으로 이동해야 함
            self.step = .mealTime
        }
    }
    
    // MARK: 확장 여지
    public func goToNote() { self.step = .note }
    public func goToUploading() { self.step = .uploading }
    public func complete() { self.step = .done }
}

import SwiftUI

struct RecordFlowEntryView: View {
    @StateObject private var root: RecordFlowRootViewModel = .init()
    
    var body: some View {
        NavigationStack {
            Group {
                switch root.step {
                case .mealTime:
                    if let viewModel = root.mealRecordVM {
                        MealRecordScreen(
                            viewModel: viewModel,
                            next: { root.proceedFromMealSelection() }
                        )
                    }
                case .tagSelect:
                    Text("태그 선택 (추가 예정)")
                        .toolbar { Button("뒤로") { root.back() } }
                case .note:
                    Text("노트 입력 (추가 예정)")
                        .toolbar { Button("뒤로") { root.back() } }
                case .uploading:
                    ProgressView("업로드 중…")
                        .toolbar { Button("뒤로") { root.back() } }
                case .done:
                    VStack(spacing: 12) {
                        Text("업로드 완료 🎉")
                        Button("다시 기록하기") {
                            root.start(date: .now)
                        }
                    }
                }
            }
            .navigationTitle("기록하기")
        }
        .task {
            if root.mealRecordVM == nil {
                root.start(date: .now)
            }
        }
    }
}

/// 기존 데모용 뷰를 실제 화면 컨테이너처럼 감싸는 얇은 래퍼
private struct MealRecordScreen: View {
    @ObservedObject var viewModel: MealRecordViewModel
    let next: () -> Void

    var body: some View {
        // 기존 MealRecordDemoView의 본문과 거의 동일
        VStack(spacing: 16) {
            Text("업로드 완료 \(viewModel.uploadedCount)/\(MealSlot.allCases.count)")
            ForEach(MealSlot.allCases, id: \.self) { slot in
                HStack {
                    Text(title(for: slot))
                    Spacer()
                    Button(viewModel.isUploaded(slot) ? "잠금" :
                           (viewModel.isSelected(slot) ? "선택됨" : "선택")) {
                        viewModel.select(slot)
                    }
                    .disabled(viewModel.isUploaded(slot))
                    .buttonStyle(.bordered)
                }.padding()
            }
            Button("업로드") {
                if let slot = viewModel.selectedSlot { viewModel.markUploaded(slot: slot) }
                next() // 다음 단계로
            }
            .disabled(viewModel.selectedSlot == nil)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }

    private func title(for slot: MealSlot) -> String {
        switch slot {
        case .breakfast: 
            return "아침"
        case .lunch:
            return "점심"
        case .dinner:
            return "저녁"
        case .snack:
            return "간식"
        }
    }
}

#Preview("Flow → MealRecordScreen") {
    RecordFlowEntryView()
}
