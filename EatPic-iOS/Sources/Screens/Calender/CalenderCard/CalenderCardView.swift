// CalenderCardView.swift
import SwiftUI

struct CalenderCardView: View {
    @EnvironmentObject private var container: DIContainer
    @Environment(\.openURL) private var openURL
    @Bindable private var toastVM = ToastViewModel()
    
    // 현재 선택된 캐러셀 아이템
    @State private var selection: ImageModel? = calendarImages.first
    
    var body: some View {
        Spacer().frame(height: 8)
        VStack {
            // 캐러셀
            CarouselView(selection: $selection, data: calendarImages)
                .padding(.horizontal, -16)
            
            buttonsView
            
            goToFeed
            Spacer()
        }
        .customNavigationBar {
            VStack(spacing: 4) {
                Text(selection?.titleText ?? "—")
                    .font(.dsTitle2)
                    .foregroundStyle(Color.gray080)
                Text(selection?.timeText ?? "—")
                    .font(.dsFootnote)
                    .foregroundStyle(Color.gray060)
            }
        } right: {
            Menu {
                Button {
                    toastVM.showToast(title: "사진 앱에 저장되었습니다.")
                } label: {
                    Label("사진 앱에 저장", systemImage: "square.and.arrow.down")
                }
                
                Button {
                    container.router.push(.picCardEdit)
                } label: {
                    Label("수정하기", systemImage: "square.and.pencil")
                }
                
                Button(role: .destructive) {
                } label: {
                    Label("삭제하기", systemImage: "exclamationmark.bubble")
                }
            } label: {
                Image("Home/btn_home_ellipsis")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .toastView(viewModel: toastVM)
        .padding(.horizontal, 16)
    }
    
    // MARK: 하단 버튼들
    private var buttonsView: some View {
        VStack(spacing: 0) {
            CalenderNavigationButton(buttonName: "레시피 링크") {
                if let urlStr = selection?.recipeURL,
                   let url = URL(string: urlStr) {
                    openURL(url)
                } else {
                    print("레시피 링크 없음")
                }
            }
            Divider()
            
            CalenderNavigationButton(buttonName: "식당 위치") {
                // 위치가 있을 때만 네비게이션
                if let item = selection,
                   let lat = item.latitude,
                   let lon = item.longitude {
                    let title = item.locationText ?? "위치"
                    container.router.push(
                        .storeLocation(latitude: lat, longitude: lon, title: title)
                    )
                } else {
                    // 위치가 없으면 아무 동작 안 함 (로그만)
                    print("위치 정보 없음")
                }
            }

            Divider()
            
            CalenderNavigationButton(buttonName: "나의 메모") {
                container.router.push(.myMemo)
            }
            Divider()
            
            CalenderNavigationButton(buttonName: "레시피 내용") {
                container.router.push(.receiptDetail)
            }
        }
        .padding(.vertical, 8)
        .background(Color.gray030.ignoresSafeArea())
        .padding(.horizontal, -16)
    }
    
    private var goToFeed: some View {
        VStack {
            Spacer().frame(height: 28)
            Button {
                // TODO: selection 기반 해당 피드로 이동
                print("해당 피드 바로가기: \(selection?.id.uuidString ?? "")")
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
