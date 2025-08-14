//
//  HashtagRecordViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/14/25.
//

import Foundation

@Observable
@MainActor
final class HashtagRecordViewModel {
    private(set) var model: HashtagRecordModel
    private(set) var catalog: HashtagCatalogProviding
    private let hashtagTitlePolicy: HashtagTitlePolicy
    
    private(set) var customAddedSinceReset: [HashtagCategory] = []
    
    init(
        date: Date = .now,
        catalog: HashtagCatalogProviding = DefaultHashtagCatalog(),
        hashtagTitlePolicy: HashtagTitlePolicy = DefaultHashtagTitlePolicy()
    ) {
        self.catalog = catalog
        self.model = .initial(for: date, catalog: catalog)
        self.hashtagTitlePolicy = hashtagTitlePolicy
    }
    
    var date: Date { model.date }
    var selectedHashtags: [HashtagCategory]? { model.selectedHashtags }
    var selectedCount: Int { model.selectedCount }
    var canSelectMore: Bool { model.canSelectMore }
    var isFull: Bool { model.isFull }
    var checks: [HashtagCheck] { model.checks }
    
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
        customAddedSinceReset.removeAll()
    }
    
    // MARK: Runtime extension (사용자에 의한 태그 추가)
    
    /**
     사용자 정의 해시태그를 모델에 추가합니다.
     
     - Parameters:
     - id: 해시태그 고유 식별자(서버/영속 키). `nil`인 경우 `title`을 가공하여 생성합니다.
     - title: 사용자에게 표시되는 해시태그 제목.
     - selectImmediately: `true`면 추가 직후 해당 해시태그를 선택 상태로 전환합니다. 기본값은 `false`입니다.
     
     - Returns:
     - `.success(HashtagCategory)`: 정상적으로 추가된 해시태그 카테고리.
     - `.failure(HashtagPolicyError)`: 제목이 비어 있거나, 길이 제한 등 정책을 위반한 경우.
     
     - Note:
     - 이 메서드는 해시태그 목록(`checks`)에 동일한 `id`가 이미 존재하면 아무 동작도 하지 않습니다.
     - 최대 선택 개수 제한(예: 3개)은 `selectImmediately` 시점의 토글 동작에 의해 적용됩니다.
     */
    @discardableResult
    func addCustomCategory(
        id: String? = nil,
        title: String,
        selectImmediately: Bool = false
    ) -> Result<HashtagCategory, HashtagPolicyError> {
        switch hashtagTitlePolicy.validate(title) {
        case .success:
            guard isDuplicateTitle(title) == false else {
                return .failure(.duplicateTitle)
            }
            
            let key = id ?? title.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: " ", with: "_")
            
            let newHashtag = HashtagCategory(id: key, title: title)
            model.appendHashtagIfNeeded(newHashtag)
            customAddedSinceReset.append(newHashtag)
            
            if selectImmediately { model.toggle(key) }
            return .success(newHashtag)
        case .failure(let err):
            return .failure(err)
        }
    }
    
    /// 입력된 title로 사용자 태그를 추가할 수 있는지 여부를 검증합니다.
    /// - Returns: 가능하면 `true`, 불가하면 `false`
    func canAdd(_ title: String) -> Bool {
        switch hashtagTitlePolicy.validate(title) {
        case .success: return !isDuplicateTitle(title)
        case .failure: return false
        }
    }
    
    private func normalized(_ title: String) -> String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
             .lowercased()
    }

    private func isDuplicateTitle(_ title: String) -> Bool {
        let key = normalized(title)
        let existing = model.checks.map { normalized($0.hashtag.title) }
        return existing.contains(key)
    }
}
