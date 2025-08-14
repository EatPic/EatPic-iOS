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
