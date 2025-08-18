//
//  RecordFlowViewModel.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/13/25.
//

import Foundation
import UIKit

// 각 화면별 데이터 취합 모델
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

// 팩토리 시그니처도 메인 액터에서만 호출되도록
typealias MealRecordVMFactory = @MainActor (_ date: Date) -> MealRecordViewModel

/// 기록 플로우의 루트 상태를 관리하는 뷰모델.
/// - 책임:
///   - `RecordFlowState`의 저장/갱신(단방향 상태)
///   - 화면 전이 가드(검증)
///   - 서버 DTO 스냅샷 생성
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

    /// 최초 진입 후 한 번만 세팅하고 싶을 때 사용(이미 값이 있으면 덮어쓰지 않게 보호)
    public func bootstrapIfNeeded(createdAt: Date, images: [UIImage]) {
        if state.images.isEmpty {
            state.createdAt = createdAt
            state.images = images
        }
    }

    public func replaceImages(_ images: [UIImage]) {
        state.images = images
    }

    public func appendImages(_ images: [UIImage]) {
        state.images.append(contentsOf: images)
    }

    public func removeImage(at index: Int) {
        guard state.images.indices.contains(index) else { return }
        state.images.remove(at: index)
    }
    
    public func addMealSlot(_ slot: MealSlot) {
        state.mealSlot = slot
    }

    public func setTags(_ tags: [HashtagCategory]) {
        state.hasTags = tags
    }

    public func setMemo(_ memo: String) {
        state.myMemo = memo
    }

    public func setRecipeText(_ text: String) {
        state.myRecipe = text
    }

    public func setRecipeLink(_ urlString: String?) {
        state.recipeLink = (urlString?.isEmpty == true) ? nil : urlString
    }

    public func setStoreLocation(_ location: String) {
        state.storeLocation = location
    }

    public func setSharedFeed(_ isOn: Bool) {
        state.sharedFeed = isOn
    }

    // MARK: - Snapshot / DTO

   // DTO 생성해서 반환하는 함수를 여기다가 만들 예정
    func getCreateCardRequestDTO() throws -> CreateCardRequest {
        let tags = state.hasTags.map(\.title)
        guard let mealSlot = state.mealSlot else {
            throw APIError.noData
        }
        return .init(
            latitude: 37.5665,
            longitude: 126.978,
            recipe: "야채, 아보카도, 소스 조합으로 구성된 샐러드입니다.",
            recipeUrl: "https://example.com/recipe/123",
            memo: "오늘은 샐러드를 먹었습니다~ 아보카도를 많이 넣었어요",
            isShared: true,
            locationText: "서울특별시 성북구 정릉동",
            meal: mealSlot,
            hashtags: tags
        )
    }

    /// 업로드 완료 후 상태를 초기화합니다. (정책에 따라 조정)
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

import UniformTypeIdentifiers
import ImageIO
import MobileCoreServices
import Moya

struct EncodedImage {
    let data: Data
    let mimeType: String
    let fileExtension: String
    let fileName: String
}

protocol ImageEncodingStrategy {
    // 최대 바이트 제약 하에 인코딩 시도. 실패하면 nil 반환
    func encode(_ image: UIImage, maxBytes: Int) -> EncodedImage?
}

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

protocol CardRepository {
    func createCard(
        request: CreateCardRequest,
        imageData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> Int
}

final class DefaultCardRepository: CardRepository {
    private let provider: MoyaProvider<CardTargetType>
    private let decoder: JSONDecoder

    init(provider: MoyaProvider<CardTargetType>, decoder: JSONDecoder = JSONDecoder()) {
        self.provider = provider
        self.decoder = decoder
    }

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
        let envelope = try decoder.decode(CreateCardResponse.self, from: response.data)
        
        guard envelope.isSuccess else {
            throw APIError.serverError(
                code: response.statusCode, message: envelope.message)
        }
        
        print("envelope: \(envelope)")
        
        return envelope.result.newCardId
    }
}

/// 이미지 업로드 과정에서 발생할 수 있는 에러
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

protocol CreateCardUseCase {
    func execute(
        state: RecordFlowState, request: CreateCardRequest) async throws -> Int
}

final class DefaultCreateCardUseCase: CreateCardUseCase {
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
