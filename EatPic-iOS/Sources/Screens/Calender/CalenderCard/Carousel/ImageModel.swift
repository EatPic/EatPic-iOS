//
//  ImageModel.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/29/25.
//

import SwiftUI

struct ImageModel: Identifiable {
    var id: UUID = UUID()
    var image: String
}

// 아침, 점심, 저녁, 간식이니 4개
var images: [ImageModel] = [
    ImageModel(image: "Home/img1"),
    ImageModel(image: "Home/img2"),
    ImageModel(image: "Home/img3"),
    ImageModel(image: "Home/img1")
] 
