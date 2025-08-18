//
//  RecordFlowViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation
import UIKit

/// 사용자가 기록 플로우에서 입력한 값을 일시적으로 모아두는 **작성 초안(draft) 상태**입니다.
/// - Note: 초기 구현 단계에서 실용성을 위해 `UIImage`를 보관합니다. 인코딩은 UseCase 내부에서 `MainActor.run`으로 수행되어
///   non-Sendable 이슈를 회피합니다. 추후 필요 시 `ImageRef(Data/URL)`로 치환하여 도메인 순수성을 강화할 수 있습니다.
struct RecordFlowState {
    var images: [UIImage]
    var mealSlot: MealSlot?
    var hasTags: [HashtagCategory]
    var myMemo: String
    var myRecipe: String
    var recipeLink: String?
    var storeLocation: String?
    var latitude: Double?
    var longitude: Double?
    var sharedFeed: Bool
    var createdAt: Date
}

/// 기록 플로우에서 날짜를 기준으로 서브 뷰모델을 생성하기 위한 팩토리 시그니처입니다.
/// - Warning: UI 스레드 제약을 명확히 하기 위해 `@MainActor`로 선언합니다.
typealias MealRecordVMFactory = @MainActor (_ date: Date) -> MealRecordViewModel

/// 기록 플로우의 루트 상태를 관리하는 뷰모델입니다.
/// - Responsibilities:
///   - `RecordFlowState`의 저장/갱신(단방향 상태)
///   - 화면 전이 가드(검증)
/// - Note: UI 업데이트 보장을 위해 `@MainActor`로 동작합니다.
@MainActor
final class RecordFlowViewModel: ObservableObject {

    /// 화면 전 단계가 공유하는 루트 상태
    @Published private(set) var state: RecordFlowState

    // MARK: - Init

    /// 최초 진입 시 루트 상태를 주입합니다.
    /// - Note: 보통 라우팅 진입 시점에서 `createdAt`, `images`를 채운 상태로 들어옵니다.
    init() {
        self.state = .init(
            images: [],
            mealSlot: nil,
            hasTags: [],
            myMemo: "",
            myRecipe: "",
            recipeLink: nil,
            storeLocation: "",
            sharedFeed: false,
            createdAt: Date()
        )
    }

    // MARK: - Derived (화면 전이 가드)

    /// 해시태그 선택 화면으로 넘어갈 수 있는지 여부
    public var canProceedToHashtag: Bool {
        !state.images.isEmpty
    }

    /// 기록(작성) 화면으로 넘어갈 수 있는지 여부
    public var canProceedToRecord: Bool {
        !state.hasTags.isEmpty && !state.images.isEmpty
    }

    /// 업로드 가능 여부(최소 요건 충족)
    public var isReadyToUpload: Bool {
        // 필요시 정책 조정: 메모/레시피/위치 필수 여부 등
        canProceedToRecord
    }

    // MARK: - Mutations (사이드이펙트 없음)

    /// 최초 진입 시 한 번만 초기 상태를 세팅합니다. 이미 값이 있으면 덮어쓰지 않습니다.
    /// - Parameters:
    ///   - createdAt: 기록 기준 시각
    ///   - images: 최초 선택된 이미지 배열
    public func bootstrapIfNeeded(createdAt: Date, images: [UIImage]) {
        if state.images.isEmpty {
            state.createdAt = createdAt
            state.images = images
        }
    }

    /// 현재 보관 중인 이미지를 전달된 배열로 교체합니다.
    public func replaceImages(_ images: [UIImage]) {
        state.images = images
    }

    /// 현재 보관 중인 이미지 배열의 뒤에 새 이미지를 추가합니다.
    public func appendImages(_ images: [UIImage]) {
        state.images.append(contentsOf: images)
    }

    /// 지정한 인덱스의 이미지를 제거합니다. 인덱스가 유효하지 않으면 무시합니다.
    /// - Parameter index: 제거할 위치
    public func removeImage(at index: Int) {
        guard state.images.indices.contains(index) else { return }
        state.images.remove(at: index)
    }
    
    /// 선택한 식사 시간대를 설정합니다.
    /// - Parameter slot: 아침/점심/저녁/간식 식사 슬롯
    public func addMealSlot(_ slot: MealSlot) {
        state.mealSlot = slot
    }

    /// 선택된 해시태그 목록을 설정합니다.
    /// - Parameter tags: 해시태그 카테고리 배열
    public func setTags(_ tags: [HashtagCategory]) {
        state.hasTags = tags
    }

    /// 사용자가 입력한 메모를 설정합니다.
    public func setMemo(_ memo: String) {
        state.myMemo = memo
    }

    /// 레시피/내용 본문을 설정합니다.
    public func setRecipeText(_ text: String) {
        state.myRecipe = text
    }

    /// 레시피 링크(URL 문자열)를 설정합니다. 빈 문자열은 `nil`로 정규화합니다.
    public func setRecipeLink(_ urlString: String?) {
        state.recipeLink = (urlString?.isEmpty == true) ? nil : urlString
    }

    /// 사용자가 지정한 위치 텍스트를 설정합니다.
    public func setStoreLocation(_ location: String) {
        state.storeLocation = location
    }

    /// 피드 공개 여부를 설정합니다.
    public func setSharedFeed(_ isOn: Bool) {
        state.sharedFeed = isOn
    }

    /// 업로드 완료 후 다음 기록을 위해 상태를 초기화합니다.
    /// - Parameter createdAt: 다음 기록의 기준 시각(기본값: 현재 시각)
    public func resetForNext(createdAt: Date = .now) {
        state.createdAt = createdAt
        state.images = []
        state.hasTags = []
        state.myMemo = ""
        state.myRecipe = ""
        state.recipeLink = nil
        state.storeLocation = ""
        state.sharedFeed = false
    }
}

/// 기록 상태를 서버 전송 DTO로 변환하는 매퍼입니다.
/// - Important: **매핑 일원화**를 위해 변환 로직을 이곳에만 둡니다.
enum CreateCardMapper {
    /// `RecordFlowState`를 서버 전송용 `CreateCardRequest`로 변환합니다.
    /// - Parameter state: 화면에서 수집한 기록 상태
    /// - Throws: `APIError.noData` — 필수 값(예: `mealSlot`)이 누락된 경우
    /// - Returns: 전송 가능한 `CreateCardRequest`
    static func makeRequest(from state: RecordFlowState) throws -> CreateCardRequest {
        let tags = state.hasTags.map(\.title)
        guard let meal = state.mealSlot else { throw APIError.noData }
        return .init(
            latitude: state.latitude ?? 0,  // 실제 값으로
            longitude: state.longitude ?? 0,
            recipe: state.myRecipe,
            recipeUrl: state.recipeLink ?? "",
            memo: state.myMemo,
            isShared: state.sharedFeed,
            locationText: state.storeLocation ?? "",
            meal: meal,
            hashtags: tags
        )
    }
}

import UniformTypeIdentifiers
import ImageIO
import MobileCoreServices
import Moya

/// 인코딩된 이미지 바이너리와 메타정보를 묶어 전달하기 위한 값 객체입니다.
/// - Note: 멀티파트 업로드 시 `fileName`, `mimeType`을 정확히 지정해야 서버/스토리지 호환성이 보장됩니다.
struct EncodedImage {
    let data: Data
    let mimeType: String
    let fileExtension: String
    let fileName: String
}

/// 이미지 인코딩 전략을 추상화한 프로토콜입니다.
/// - Parameters:
///   - image: 원본 이미지(`UIImage`)
///   - maxBytes: 인코딩 결과가 넘지 말아야 할 최대 바이트
/// - Returns: 조건을 만족하는 `EncodedImage` 또는 실패 시 `nil`
protocol ImageEncodingStrategy {
    // 최대 바이트 제약 하에 인코딩 시도. 실패하면 nil 반환
    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage?
}

/// HEIC 포맷으로 인코딩하는 전략입니다. 알파 채널이 있을 경우 배경 합성 후 손실 압축을 수행합니다.
/// - Warning: 일부 서버/라이브러리는 `image/heic`를 지원하지 않을 수 있습니다.
final class HEICEncoder: ImageEncodingStrategy {
    private let quality: CGFloat
    private let filenameBase: String

    init(quality: CGFloat = 0.85, filenameBase: String = "image") {
        self.quality = quality
        self.filenameBase = filenameBase
    }

    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage? {
        guard let cgImage = image.cgImage else { return nil }
        guard let utType = UTType.heic.identifier as CFString? else { return nil }

        // 알파가 있는 경우: 필요 시 배경색 합성으로 알파 제거
        let source: CGImage
        if image.hasAlpha, let flattened = image.flattened(background: .white) {
            guard let cgImg = flattened.cgImage else { return nil }
            source = cgImg
        } else {
            source = cgImage
        }

        // 가변 품질로 시도 (간단 이분탐색)
        var low: CGFloat = 0.4
        var high: CGFloat = quality
        var bestData: Data?

        for _ in 0..<6 {
            let quality = (low + high) / 2
            guard let data = Self.encodeHEIC(
                cgImage: source, quality: quality, utType: utType) else { break }
            if data.count > maxBytes {
                high = quality
            } else {
                bestData = data
                low = quality
            }
        }

        guard let final = bestData else { return nil }
        return EncodedImage(
            data: final,
            mimeType: "image/heic",
            fileExtension: "heic",
            fileName: "\(filenameBase).heic"
        )
    }

    private static func encodeHEIC(
        cgImage: CGImage,
        quality: CGFloat,
        utType: CFString
    ) -> Data? {
        let data = NSMutableData()
        guard let dest = CGImageDestinationCreateWithData(
            data, utType, 1, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: quality
        ]
        CGImageDestinationAddImage(dest, cgImage, options as CFDictionary)
        guard CGImageDestinationFinalize(dest) else { return nil }
        return data as Data
    }
}

private extension UIImage {
    var hasAlpha: Bool {
        guard let alpha = cgImage?.alphaInfo else { return false }
        switch alpha {
        case .first, .last, .premultipliedFirst, .premultipliedLast: return true
        default: return false
        }
    }

    /// 알파를 버려도 될 때 배경에 합성
    func flattened(background: UIColor) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            background.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

/// JPEG 포맷으로 인코딩하는 전략입니다. 이분 탐색으로 품질을 조정하여 목표 용량을 만족시킵니다.
final class JPEGEncoder: ImageEncodingStrategy {
    private let filenameBase: String
    init(filenameBase: String = "image") {
        self.filenameBase = filenameBase
    }

    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage? {
        // 이분탐색으로 품질 조절
        var low: CGFloat = 0.3, high: CGFloat = 0.9
        var best: Data?
        for _ in 0..<6 {
            let quality = (low + high) / 2
            guard let data = image.jpegData(
                compressionQuality: quality) else { break }
            if data.count > maxBytes {
                high = quality
            } else {
                best = data
                low = quality
            }
        }
        guard let data = best else { return nil }
        return EncodedImage(
            data: data,
            mimeType: "image/jpeg",
            fileExtension: "jpg",
            fileName: "\(filenameBase).jpg"
        )
    }
}

/// PNG 포맷으로 인코딩하는 전략입니다. 무손실이지만 용량이 커질 수 있습니다(최대 바이트 초과 시 실패).
final class PNGEncoder: ImageEncodingStrategy {
    private let filenameBase: String
    init(filenameBase: String = "image") {
        self.filenameBase = filenameBase
    }

    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage? {
        guard let data = image.pngData(),
                data.count <= maxBytes else { return nil }
        return EncodedImage(
            data: data,
            mimeType: "image/png",
            fileExtension: "png",
            fileName: "\(filenameBase).png"
        )
    }
}

/// 등록된 전략 순서대로 인코딩을 시도하는 파이프라인입니다. 최초 성공 결과를 반환합니다.
struct ImageEncoderPipeline: ImageEncodingStrategy {
    private let strategies: [ImageEncodingStrategy]
    init(_ strategies: [ImageEncodingStrategy]) {
        self.strategies = strategies
    }

    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage? {
        for strategy in strategies {
            if let out = strategy.encode(
                image, maxBytes: maxBytes) { return out }
        }
        return nil
    }
}

/// PicCard 생성/조회 등 카드 관련 데이터를 다루는 도메인 리포지토리 인터페이스입니다.
/// - Note: 도메인 계층의 추상화로서, Moya/URLSession 등의 세부 구현을 알지 못합니다.
protocol CardRepository {
    func createCard(
        request: CreateCardRequest,
        imageData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> Int
}

/// `CardRepository`의 기본 구현체입니다. Moya를 통해 원격 API와 통신합니다.
/// - Important: 이 계층에서만 DTO/네트워크 세부사항을 다루고, 상위에는 도메인 타입/원시값만 노출합니다.
final class CardRepositoryImpl: CardRepository {
    private let provider: MoyaProvider<CardTargetType>
    private let decoder: JSONDecoder

    init(provider: MoyaProvider<CardTargetType>, decoder: JSONDecoder = JSONDecoder()) {
        self.provider = provider
        self.decoder = decoder
    }

    /// PicCard를 생성합니다(멀티파트 업로드).
    /// - Parameters:
    ///   - request: 전송할 본문 JSON(`CreateCardRequest`)
    ///   - imageData: 업로드할 이미지 바이너리
    ///   - fileName: 파일명(확장자 포함)
    ///   - mimeType: MIME 타입(예: `image/heic`, `image/jpeg`)
    /// - Returns: 생성된 카드의 식별자(`newCardId`)
    /// - Throws: 네트워크/디코딩/서버 오류에 따른 도메인 에러
    func createCard(
        request: CreateCardRequest,
        imageData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> Int {
        let response = try await provider.requestAsync(
            .createFeed(
                request: request,
                image: imageData,
                fileName: fileName,
                mimeType: mimeType
            )
        )
        let envelope = try decoder.decode(APIResponse<CreateCardResult>.self, from: response.data)
        
        guard envelope.isSuccess else {
            throw APIError.serverError(
                code: response.statusCode, message: envelope.message)
        }
        
        return envelope.result.newCardId
    }
}

/// 업로드 과정에서 발생할 수 있는 도메인 에러입니다. 사용자 메시지로 변환하기 쉽도록 `LocalizedError`를 채택합니다.
enum UploadError: LocalizedError {
    /// 업로드할 이미지가 없는 경우
    case missingImage
    /// 인코딩(압축/변환)에 실패한 경우
    case encodingFailed
    /// 서버 응답이 비정상일 때
    case invalidServerResponse
    /// 네트워크 오류
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .missingImage:
            return "업로드할 이미지가 없습니다."
        case .encodingFailed:
            return "이미지를 인코딩하는 데 실패했습니다."
        case .invalidServerResponse:
            return "서버 응답이 올바르지 않습니다."
        case .networkError(let error):
            return "네트워크 오류가 발생했습니다: \(error.localizedDescription)"
        }
    }
}

/// `CreateCardUseCase`의 기본 구현체입니다.
/// - Note: `UIImage`는 non-Sendable이므로, 인코딩은 `MainActor.run`에서 수행하여 안전성을 확보합니다.
protocol CreateCardUseCase {
    /// 기록 상태와 DTO를 받아 이미지 인코딩 후 서버에 업로드합니다.
    /// - Parameters:
    ///   - state: 화면에서 수집한 기록 상태
    ///   - request: 서버 전송용 DTO
    /// - Returns: 생성된 카드의 식별자
    /// - Throws: `UploadError` 및 레포지토리에서 전달되는 도메인 에러
    func execute(
        state: RecordFlowState,
        request: CreateCardRequest
    ) async throws -> Int
}

final class CreateCardUseCaseImpl: CreateCardUseCase {
    private let repository: CardRepository
    private let encoder: ImageEncodingStrategy
    private let maxBytes: Int

    init(
        repository: CardRepository,
        encoder: ImageEncodingStrategy = ImageEncoderPipeline(
            [HEICEncoder(), JPEGEncoder(), PNGEncoder()]),
        maxBytes: Int = 1_000_000,
    ) {
        self.repository = repository
        self.encoder = encoder
        self.maxBytes = maxBytes
    }

    func execute(
        state: RecordFlowState,
        request: CreateCardRequest
    ) async throws -> Int {
        let uiImage: UIImage = try await MainActor.run {
            guard let img = state.images.first else { throw UploadError.missingImage }
            return img
        }
        
        // 파이프라인 인코딩도 메인에서 수행 (UIImage는 non-Sendable)
        let encoded: EncodedImage = try await MainActor.run {
            guard let out = encoder.encode(uiImage, maxBytes: maxBytes) else {
                throw UploadError.encodingFailed
            }
            return out
        }
        
        // Sendable(EncodedImage.data 등)만 다루므로 어느 Actor에서도 안전
        // 추후 여유 생기면, 메인에서 한 번만 UIImage -> Data로 변환하고,
        // 데이터 기반 파이프라인으로 바꿔서 인코딩을 백그라운드로 돌릴 예정
        return try await repository.createCard(
            request: request,
            imageData: encoded.data,
            fileName: encoded.fileName,
            mimeType: encoded.mimeType
        )
    }
}
