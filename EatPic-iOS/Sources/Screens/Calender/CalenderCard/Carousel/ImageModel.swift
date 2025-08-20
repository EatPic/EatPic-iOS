// ImageModel.swift
import SwiftUI

struct ImageModel: Identifiable, Equatable {
    let id = UUID()
    let image: String
    
    // 상단바/버튼에 쓸 메타데이터
    let titleText: String        // 예: "8월 1일 아침"
    let timeText: String         // 예: "오후 1시 10분"
    
    let recipeURL: String?       // 레시피 링크 유무
    
    // 위치 정보
    let latitude: Double?
    let longitude: Double?
    let locationText: String?
    
    let memo: String?            // 메모 유무

}

// 더미 데이터
let calendarImages: [ImageModel] = [
    .init(image: "Home/img1",
          titleText: "8월 1일 아침",
          timeText: "오후 1시 10분",
          recipeURL: "https://example.com/recipe-1001",
          latitude: 37.5665,
          longitude: 126.9780,
          locationText: "서울 시청",
          memo: "아침엔 가볍게 샐러드"),
    .init(image: "Home/img2",
          titleText: "8월 1일 점심",
          timeText: "오후 1시 03분",
          recipeURL: nil,
          latitude: nil,
          longitude: nil,
          locationText: nil,
          memo: nil),
    .init(image: "Home/img3",
          titleText: "8월 1일 저녁",
          timeText: "오후 6시 42분",
          recipeURL: "https://example.com/recipe-202",
          latitude: 37.5665,
          longitude: 126.9780,
          locationText: "서울 시청",
          memo: "탄단지 골고루!"),
    .init(image: "Home/img1",
          titleText: "8월 1일 간식",
          timeText: "오후 9시 10분",
          recipeURL: nil,
          latitude: nil,
          longitude: nil,
          locationText: nil,
          memo: nil)
]
