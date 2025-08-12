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

// 팩토리 시그니처도 메인 액터에서만 호출되도록
typealias MealRecordVMFactory = @MainActor (_ date: Date) -> MealRecordViewModel

import SwiftUI

struct MealRecorView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel: MealRecordViewModel
    private let images: [UIImage]
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(
        date: Date,
        images: [UIImage],
        factory: @escaping MealRecordVMFactory = {
            MealRecordViewModel(model: .initial(for: $0))
        }
    ) {
        self.images = images
        _viewModel = .init(wrappedValue: factory(date))
    }

    var body: some View {
        VStack {
            Image("Record/img_record_itcong")
                .resizable()
                .frame(width: 180, height: 180)
            
            Spacer().frame(height: 36)
            
            HStack {
                Text("이번에 기록할 \n식사는 언제 드신 건가요?")
                    .font(.dsTitle2)
                    .foregroundStyle(.black)
                Spacer()
            }
            
            Spacer().frame(height: 32)
            
            // 식사 시간 선택 버튼들
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(MealSlot.allCases, id: \.self) { slot in
                    MealButton(
                        mealType: slot,
                        isSelected: viewModel.isSelected(slot)
                    ) {
                        viewModel.select(slot)
                    }
                }
            }
            
            Spacer().frame(height: 102)
            
            // 하단 다음 버튼
            PrimaryButton(
                color: viewModel.selectedSlot == nil ? .gray020 : .green060,
                text: "다음",
                font: .dsTitle3,
                textColor: viewModel.selectedSlot == nil ? .gray040 : .white,
                width: 361,
                height: 48,
                cornerRadius: 10
            ) {
                guard let selectedSlot = viewModel.selectedSlot else { return }
                container.router.push(
                    .hashtagSelection(selectedMeal: selectedSlot))
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
}

// MARK: - 식사 시간 버튼 (아침 ~간식)
private struct MealButton: View {
    let mealType: MealSlot // 아침, 점심, 저녁, 간식
    let isSelected: Bool // 현재 선택 상태
    let action: () -> Void // 클릭 시 실행할 동작

    // 버튼에 표시할 텍스트
    private var title: String {
        switch mealType {
        case .breakfast: "아침"
        case .lunch:     "점심"
        case .dinner:    "저녁"
        case .snack:     "간식"
        }
    }

    // 버튼에 표시할 아이콘
    private var icon: Image {
        switch mealType {
        case .breakfast: Image("Record/ic_home_morning")
        case .lunch:     Image("Record/ic_home_lunch")
        case .dinner:    Image("Record/ic_home_dinner")
        case .snack:     Image("Record/ic_home_dessert")
        }
    }

    // 선택 상태에 따른 버튼 관련 색상 값
    private var backgroundColor: Color { isSelected ? .green010 : .white }
    private var borderColor: Color { isSelected ? .green060 : .gray050 }
    private var textColor: Color { isSelected ? .green060 : .gray050 }

    var body: some View {
        Button(action: action) {
            VStack {
                icon
                    .renderingMode(.template)
                    .foregroundStyle(textColor)
                Text(title)
                    .font(.dsHeadline)
                    .foregroundStyle(textColor)
            }
            .padding(.horizontal, 20)
            .frame(width: 170, height: 100)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MealtimeSelectView()
        .environmentObject(PicCardRecorViewModel())
}
