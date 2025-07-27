//
//  MyBadgeStatusViewModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/27/25.
//


import Foundation

class MyBadgeStatusViewModel: ObservableObject {
    
    @Published var cards: [RecomPicCardModel] = [
        RecomPicCardModel(imageName: "Home/img1"),
        RecomPicCardModel(imageName: "Home/img2"),
        RecomPicCardModel(imageName: "Home/img3"),
        RecomPicCardModel(imageName: "Home/img1"),
        RecomPicCardModel(imageName: "Home/img2"),
        RecomPicCardModel(imageName: "Home/img3")
    ]
}
