////
////  RecomPicSingleCardViewModel.swift
////  EatPic-iOS
////
////  Created by 이은정 on 8/19/25.
////
//
//import Foundation
//import SwiftUI
//import Moya
//
//@Observable
//class RecomPicSingleCardViewModel {
//    private let cardProvider: MoyaProvider<CardTargetType>
//    
//    //    var card: PicCard
//    // 처음엔 비어있고, 로딩 이후에 채움
//    var card: PicCard?
//    
//    init(container: DIContainer) {
//        self.cardProvider = container.apiProviderStore.card()
//    }
//    
//    @MainActor
//    func recomPicSingleCard(cardId: Int) async {
//        do {
//            let response = try await cardProvider.requestAsync(.recomPicSingleCard(cardId: cardId))
//            let dto = try JSONDecoder().decode(
//                SingleCardFeedResponse.self,
//                from: response.data)
//            
//            // 도메인 모델로 변환
//            let picCard = dto.result.toPicCard()
//            
//            // UI 업데이트를 위해 card 속성에 할당
//            self.card = picCard
//            
//            print(dto)
//            
//        } catch {
//            print("요청 또는 디코딩 실패:", error.localizedDescription)
//        }
//    }
//}


import Foundation
import SwiftUI
import Moya

struct APIErrorResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}

@Observable
class RecomPicSingleCardViewModel {
    private let cardProvider: MoyaProvider<CardTargetType>

    // 화면 상태
    var card: PicCard?
    var isLoading = false
    var errorMessage: String?

    init(container: DIContainer) {
        self.cardProvider = container.apiProviderStore.card()
    }

    // 단건 조회
    func recomPicSingleCard(cardId: Int) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            let response = try await cardProvider.requestAsync(.recomPicSingleCard(cardId: cardId))
            let dto = try JSONDecoder().decode(SingleCardFeedResponse.self, from: response.data)
            let picCard = dto.result.toPicCard()

            await MainActor.run {
                self.card = picCard
                self.isLoading = false
            }
        } catch let moyaError as MoyaError {
            // 4xx/5xx 응답 처리
            if let resp = moyaError.response {
                let apiErr = try? JSONDecoder().decode(APIErrorResponse.self, from: resp.data)
                await MainActor.run {
                    self.card = nil
                    self.isLoading = false
                    switch apiErr?.code {
                    case "CARD_001":
                        // 서버: 해당 카드 없음
                        self.errorMessage = "해당 카드를 찾을 수 없어요. (id: \(cardId))"
                    case "USER_004":
                        // 서버: 토큰 문제
                        self.errorMessage = "로그인이 필요해요. 다시 로그인해 주세요."
                    default:
                        self.errorMessage = apiErr?.message
                        ?? "요청 실패 (\(resp.statusCode))"
                    }
                }
            } else {
                await MainActor.run {
                    self.card = nil
                    self.isLoading = false
                    self.errorMessage = "네트워크 오류: \(moyaError.errorDescription ?? "알 수 없는 오류")"
                }
            }
        } catch {
            await MainActor.run {
                self.card = nil
                self.isLoading = false
                self.errorMessage = "디코딩 실패: \(error.localizedDescription)"
            }
        }
    }
}
