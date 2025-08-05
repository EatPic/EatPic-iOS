//
//  ImageLoaderServiceTest.swift
//  EatPic-iOSTests
//
//  Created by jaewon Lee on 8/5/25.
//

import Testing
import XCTest
import UIKit
import Kingfisher
@testable import EatPic_iOS

@Suite
struct ImageLoaderServiceTest {

    @Test("올바른 이미지 URL 로드 시 success 상태가 되어야 한다.")
    func testSuccessfulImageLoad() async throws {
        // given
        let loader = ImageLoaderServiceImpl()
        let urlString = """
                https://upload.wikimedia.org/
                wikipedia/commons/thumb/3/3c/
                Shaki_waterfall.jpg/320px-Shaki_waterfall.jpg
                """
        
        // when
        await loader.loadImage(from: urlString)
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // then
        switch loader.state {
        case .success(let image):
            #expect(image.size.width > 0)
        default:
            XCTFail("이미지 로드 실패: \(loader.state)")
        }
    }

    @Test("잘못된 URL을 입력하면 failure 상태가 되어야 한다.")
    func testInvalidURL() async {
        // given
        let loader = ImageLoaderServiceImpl()
        
        // when
        await loader.loadImage(from: "valid url")
        
        // then
        switch loader.state {
        case .failure(let error):
            #expect(error is URLError)
        default:
            XCTFail("에러 상태가 되어야 한다.")
        }
    }
    
    @Test("이미 캐시된 이미지를 로드하면 success 상태가 되어야 한다.")
    func testCachedImageLoad() async throws {
        // given
        let loader = ImageLoaderServiceImpl()
        let cache = ImageCache.default
        let testKey = "https://example.com/cached_image.jpg"
        
        // when
        // 테스트용 이미지 (1x1 pixel)
        guard let dummyImage = UIImage(systemName: "checkmark") else {
            return
        }
        try await cache.store(dummyImage, forKey: testKey)
        
        await loader.loadImage(from: testKey)
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // then
        switch loader.state {
        case .success(let image):
            #expect(image.size != .zero)
        default:
            XCTFail("캐시 이미지 로드 실패")
        }
    }
}
