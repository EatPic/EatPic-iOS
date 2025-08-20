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
                    default:
                        self.errorMessage = apiErr?.message
                        ?? "요청 실패 (\(resp.statusCode))"
                    }
                }
            }
        }
        catch {
            await MainActor.run {
                self.card = nil
                self.isLoading = false
                self.errorMessage = "디코딩 실패: \(error.localizedDescription)"
            }
        }
    }
}
