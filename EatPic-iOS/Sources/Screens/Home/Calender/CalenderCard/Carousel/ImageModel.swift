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

var images: [ImageModel] = [
    ImageModel(image: "Home/img1"),
    ImageModel(image: "Home/img1"),
    ImageModel(image: "Home/img2"),
    ImageModel(image: "Home/img2"),
    ImageModel(image: "Home/img3"),
    ImageModel(image: "Home/img3")
] 
