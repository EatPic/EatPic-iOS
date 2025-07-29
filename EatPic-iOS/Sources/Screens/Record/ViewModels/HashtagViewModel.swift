//
//  HashtagViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/29/25.
//

import Foundation

class HashtagViewModel: ObservableObject {
    @Published var hashtags: [HashtagModel] = [
        HashtagModel(name: "야식"),
        HashtagModel(name: "브런치"),
        HashtagModel(name: "혼밥"),
        HashtagModel(name: "집밥"),
        HashtagModel(name: "식단관리"),
        HashtagModel(name: "자취생"),
        HashtagModel(name: "건강"),
        HashtagModel(name: "맛집"),
        HashtagModel(name: "비건"),
        HashtagModel(name: "한식"),
        HashtagModel(name: "양식"),
        HashtagModel(name: "중식"),
        HashtagModel(name: "일식")
    ]
}
