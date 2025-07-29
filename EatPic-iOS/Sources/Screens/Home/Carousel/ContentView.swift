//
//  ContentView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/29/25.
//

import SwiftUI

struct ContentView: View {
    @State private var activeID: UUID?
    
    
    var body: some View {
        NavigationStack{
            VStack{
                CustomCarousel(config: .init(), selection: $activeID, data: images) {
                    item in
                    Image(item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(height: 120)
            }
            .navigationTitle(Text("Cover Carousel"))
        }
    }
}
