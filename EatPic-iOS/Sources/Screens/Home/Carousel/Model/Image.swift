//
//  Image.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/29/25.
//

import SwiftUI


struct ImageModel: Identifiable {
    var id: UUID = UUID()
    var image: String
}

var images: [ImageModel] = [1...0].compactMap({ ImageModel(image: "Profile \($0)")})
