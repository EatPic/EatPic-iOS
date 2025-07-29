//
//  Cell.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 7/29/25.
//

import SwiftUI

struct Cell: View {
    
    var calendarDay: CalendarDay
    @Bindable var viewModel: CalendarViewModel
    
    var body: some View {
        ZStack {
            if let image = calendarDay.meta?.img {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 43, height: 43)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Rectangle()
                    .fill(rectangleFillColor)
                    .frame(width: 43, height: 43)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Text("\(calendarDay.day)")
                .font(.dsHeadline)
                .foregroundStyle(textColor)
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDate)
        }
        .frame(height: 50)
    }
    
    private var textColor: Color {
        if calendarDay.meta?.img != nil {
            return Color.white
        } else {
            if calendarDay.isCurrentMonth {
                return Color.gray080
            } else {
                return Color.gray080.opacity(0.2)
            }
        }
    }
    
    private var rectangleFillColor: Color {
        if calendarDay.isCurrentMonth {
            return Color.gray020
        } else {
            return Color.gray020.opacity(0.2)
        }
    }
}
