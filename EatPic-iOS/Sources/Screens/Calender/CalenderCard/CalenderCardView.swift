// CalenderCardView.swift
import SwiftUI

struct CalenderCardView: View {
    @EnvironmentObject private var container: DIContainer
    @Environment(\.openURL) private var openURL
    @Bindable private var toastVM = ToastViewModel()

    // ⬇️ 더미 데이터로 초기화 (나중에 서버 데이터로 대체)
    @State private var items: [ImageModel] = calendarImages
    @State private var selection: ImageModel? = calendarImages.first

    var body: some View {
        Spacer().frame(height: 8)
        VStack {
            // ⬇️ 캐러셀에 items 주입
            CarouselView(selection: $selection, data: items)
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

                // ⬇️ 삭제하기 구현
                Button(role: .destructive) {
                    deleteCurrentSelection()
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
        .onChange(of: items) { newValue in
            // 방어적으로: items가 비면 selection도 nil 처리
            if newValue.isEmpty { selection = nil }
        }
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

extension CalenderCardView {
    private func deleteCurrentSelection() {
        guard let selected = selection,
              let idx = items.firstIndex(where: { $0.id == selected.id }) else {
            return
        }

        // 실제 삭제
        items.remove(at: idx)

        // 다음 selection 결정: 다음 → 이전 → nil
        if idx < items.endIndex {
            selection = items[idx]               // 바로 오른쪽 카드
        } else if !items.isEmpty {
            selection = items[items.index(before: items.endIndex)] // 마지막 카드로
        } else {
            selection = nil
            // 모두 삭제됨: 라우팅 처리 (원하는 UX에 맞게 선택)
            // 1) 뒤로 가기
            container.router.pop()
            // 2) 또는 토스트만 띄우고 빈 상태 유지
            // toastVM.showToast(title: "모든 기록이 삭제되었습니다.")
        }

        toastVM.showToast(title: "삭제되었습니다.")
    }
}


#Preview {
    CalenderCardView()
        .environmentObject(DIContainer())
}
