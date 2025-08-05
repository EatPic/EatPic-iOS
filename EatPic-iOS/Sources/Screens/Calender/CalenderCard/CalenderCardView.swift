//
//  CalenderCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct CalenderCardView: View {
    @EnvironmentObject private var container: DIContainer
    
    @Bindable private var toastVM = ToastViewModel()
    
    var body: some View {

        Spacer().frame(height: 8)
        
        VStack {
            
            // 당일 식사 사진들 캐러셀 뷰
            // FIXME: [25.07.29] 각 Carousel 사진마다 개별 뷰 보여줘야함 – 비엔/이은정
            CarouselView()
            
            buttonsView
            
            goToFeed
            
            Spacer()
        }
        .customNavigationBar {
            VStack(spacing: 4) {
                // TODO: Calender 날짜 + 식사 시간(아침/점심/저녁/간식) 불러와야 함
                Text("8월 1일 아침")
                    .font(.dsTitle2)
                    .foregroundColor(Color.gray080)
                
                // TODO: 해당 PicCard가 저장된 시간 불러와야 함
                Text("오후 1시 10분")
                    .font(.dsFootnote)
                    .foregroundColor(Color.gray060)
            }
        } right: {
            Menu {
                // FIXME: [25.07.30] 버튼을 개별 뷰로 분리하면 조금 더 깔끔해질것같음 – 비엔/이은정
                
                Button(action: {
                    toastVM.showToast(title: "사진이 저장되었습니다.")
                    // TODO: [25.07.27] 다운로드 액션 – 비엔/이은정
                }, label: {
                    Label("사진 앱에 저장", systemImage: "square.and.arrow.down")
                })
                
                Button(action: {
                    container.router.push(.picCardEdit)
                }, label: {
                    Label("수정하기", systemImage: "square.and.pencil")
                })
                
                Button(role: .destructive, action: {
                    // TODO: [25.07.27] 해당 PicCard 삭제 액션 – 비엔/이은정
                }, label: {
                    Label("삭제하기", systemImage: "exclamationmark.bubble")
                })
            } label: {
                Image("Home/btn_home_ellipsis")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .toastView(viewModel: toastVM)
        .padding(.horizontal, 16)
    }
    
    // MARK: 레시피 링크 ~ 메모 등의 하단 버튼 뷰 4개
    private var buttonsView: some View {
        ZStack {
            // VStack은 기본적으로
            // 각 자식 뷰 사이에 spacing을 주기 때문에
            // spacing을 0으로 처리
            VStack(spacing: 0) {
                
                CalenderNavigationButton(
                    buttonName: "레시피 링크"
                ) {
                    print("레시피 링크 열기")
                    // TODO: [25.07.24] 담아놓은 레시피 Link 연결하여 브라우저에서 열기 – 비엔/이은정
                }
                
                Divider()
                    .frame(width: .infinity)
                
                CalenderNavigationButton(
                    buttonName: "식당 위치"
                ) {
                    print("식당 위치 뷰로 이동")
                    // TODO: [25.07.29] StoreLocationView로 Navigation << 이거 계속 안되는디 ㅜㅜ – 비엔/이은정
                }
                
                Divider()
                    .frame(width: .infinity)
                
                CalenderNavigationButton(
                    buttonName: "나의 메모"
                ) {
                    container.router.push(.myMemo)
                }
                
                Divider()
                    .frame(width: .infinity)
                
                CalenderNavigationButton(
                    buttonName: "레시피 내용"
                ) {
                    container.router.push(.receiptDetail)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color.gray030.ignoresSafeArea())
    }
    
    // MARK: 해당 피드 바로가기 버튼 있는 뷰
    private var goToFeed: some View {
        VStack {
            
            Spacer().frame(height: 28)
            
            Button {
                // TODO: [25.07.23] 해당 피드 뷰로 Navigation – 비엔/이은정
                print("해당 피드 바로가기 버튼 클릭")
            } label: {
                HStack {
                    Text("해당 피드 바로가기")
                        .underline()
                        .font(.dsSubhead)
                        .foregroundStyle(Color.gray060)
                }
            }
        }
    }
}

#Preview {
    CalenderCardView()
        .environmentObject(DIContainer())
}
