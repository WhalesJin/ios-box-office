//
//  ImageManagerTests.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/10.
//

import XCTest
@testable import BoxOffice

final class ImageManagerTests: XCTestCase {
    private let image = UIImage(named: "default_image")
    private var imageManager: ImageManager!
    
    func testFetchImage() {
        let expectation = XCTestExpectation(description: "fetchImage")
        expectation.expectedFulfillmentCount = 1
        
        let data: Data = image!.jpegData(compressionQuality: 1)!
        let networkManager = MockSuccessNetworkManager(data: data)
        imageManager = ImageManager(networkManager: networkManager)
        
        imageManager.fetchImage(url: URL(string: "sample1")) { result in
            switch result {
            case .success(let image):
                networkManager.verify(url: URL(string: "sample1"),
                                      method: .get,
                                      header: nil)
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchImageFailure() {
        let expectation = XCTestExpectation(description: "fetchImageFailure")
        
        let networkManager = MockFailureNetworkManager(error: .noData)
        imageManager = ImageManager(networkManager: networkManager)
        
        imageManager.fetchImage(url: URL(string: "sample1")) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
