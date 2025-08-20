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
    @EnvironmentObject private var container: DIContainer
    
    private var imageURL: String? {
            viewModel.image(for: calendarDay.date)
        }
    
    var body: some View {
        ZStack {
            Group {
                if viewModel.hasImage(for: calendarDay.date),
                   calendarDay.isCurrentMonth {
                    Rectangle()
                        .remoteImage(url: imageURL)
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(rectangleFillColor)
                }
            }
            .frame(width: 43, height: 43)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("\(calendarDay.day)")
                .font(.dsHeadline)
                .foregroundStyle(textColor)
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDate)
        }
        .frame(height: 50)
        .onTapGesture {
            // 이미지가 있는 날짜만 네비게이션
            if viewModel.hasImage(for: calendarDay.date),
                calendarDay.isCurrentMonth {
                container.router.push(.calenderCard)
            }
        }
    }
    
    private var textColor: Color {
        if viewModel.hasImage(for: calendarDay.date),
           calendarDay.isCurrentMonth {
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
