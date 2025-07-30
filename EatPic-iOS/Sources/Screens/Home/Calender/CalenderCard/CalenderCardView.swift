//
//  CalenderCardView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 7/23/25.
//

import SwiftUI

struct CalenderCardView: View {
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {

        Spacer().frame(height: 8)
        
        VStack {
            
            // 당일 식사 사진들 캐러셀 뷰
            // FIXME: 각 Carousel 사진마다 개별 뷰 보여줘야하는거 아닌가..? 아니아니 개별뷰가 아니라 각각의 사진마다 상단바의 시간도 다르고 아래 뜨는 버튼눌럿을때 나오는 내용이 달라져야하는디 흠
            CarouselView()
            
            buttonsView
            
            goToFeed
            
            Spacer()
        }
        .customNavigationBar {
            VStack(spacing: 4) {
                // TODO: Calender 날짜 + 식사 시간(아침/점심/저녁/간식) 불러와야 함
                Text("7월 1일 아침")
                    .font(.dsTitle2)
                    .foregroundColor(Color.gray080)
                
                // TODO: 해당 PicCard가 저장된 시간 불러와야 함
                Text("오후 1시 10분")
                    .font(.dsFootnote)
                    .foregroundColor(Color.gray060)
            }
        } right: {
            Menu {
                // FIXME: 여기 버튼들 개별 뷰로 분리!!!!!!!!!
                
                Button(action: {
                    // TODO: 다운로드 액션
                }, label: {
                    Label("사진 앱에 저장", systemImage: "square.and.arrow.down")
                })
                
                Button(action: {
                    // TODO: PicCardEditView로 네비게이션
                    container.router.push(.picCardEditView)
                }, label: {
                    Label("수정하기", systemImage: "square.and.pencil")
                })
                
                Button(role: .destructive, action: {
                    // TODO: 해당 PicCard 삭제 액션
                }, label: {
                    Label("삭제하기", systemImage: "exclamationmark.bubble")
                })
            } label: {
                Image("Home/btn_home_ellipsis")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
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
                    // TODO: 담아놓은 레시피 Link 연결하여 브라우저에서 열기 < ?
                }
                
                Divider()
                    .frame(width: .infinity)
                
                CalenderNavigationButton(
                    buttonName: "식당 위치"
                ) {
                    print("식당 위치 뷰로 이동")
                    // TODO: StoreLocationView로 Navigation << 이거 계속 안되는디 ㅜㅜ
//                        container.router.push(.storeLocation(makers: markers)
                    
                }
                
                Divider()
                    .frame(width: .infinity)
                
                CalenderNavigationButton(
                    buttonName: "나의 메모"
                ) {
                    print("나의 메모 뷰로 이동")
                    // TODO: MyMemoView로 Navigation
                    container.router.push(.myMemoView)
                }
                
                Divider()
                    .frame(width: .infinity)
                
                CalenderNavigationButton(
                    buttonName: "레시피 내용"
                ) {
                    print("레시피 내용 뷰로 이동")
                    // TODO: ReceiptDetailView로 Navigation
                    container.router.push(.receiptDetailView)
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
                // TODO: 해당 피드 뷰로 Navigation (이건 뭐지???)
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
